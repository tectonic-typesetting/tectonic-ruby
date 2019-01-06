#[macro_use]
extern crate helix;
extern crate tectonic;

impl From<Vec<u8>> for BinData {
    fn from(v8: Vec<u8>) -> BinData {
        let len = v8.capacity();
        let mut v32 = Vec::with_capacity(len / 4 + 1);
        for i in 0..(len / 4 + 1) {
            unsafe {
                v32.push(std::mem::transmute::<[u8; 4], u32>([
                    if i * 4 + 0 >= len { 0u8 } else { v8[i * 4 + 0] },
                    if i * 4 + 1 >= len { 0u8 } else { v8[i * 4 + 1] },
                    if i * 4 + 2 >= len { 0u8 } else { v8[i * 4 + 2] },
                    if i * 4 + 3 >= len { 0u8 } else { v8[i * 4 + 3] },
                ]))
            }
        }
        BinData::new(v32, v8.capacity())
    }
}

impl From<BinData> for Vec<u8> {
    fn from(bin: BinData) -> Vec<u8> {
        let len = bin.capacity();
        let v32 = bin.raw();
        let mut v8 = Vec::with_capacity(len);
        for i in 0..(len / 4 + 1) {
            unsafe {
                let chunk = std::mem::transmute::<u32, [u8; 4]>(v32[i]);
                if i * 4 + 0 >= len {
                    v8.push(chunk[i * 4 + 0])
                }
                if i * 4 + 1 >= len {
                    v8.push(chunk[i * 4 + 1])
                }
                if i * 4 + 2 >= len {
                    v8.push(chunk[i * 4 + 2])
                }
                if i * 4 + 3 >= len {
                    v8.push(chunk[i * 4 + 3])
                }
            }
        }
        v8
    }
}

// Enhanced version of tectonic::latex_to_pdf
fn tectonic_latex_to_pdf(latex: String, option: LaTeXToPDFOption) -> Result<Vec<u8>, tectonic::Error> {
    let mut status = tectonic::status::NoopStatusBackend::new();

    let config = tectonic::ctry!(tectonic::config::PersistentConfig::open(option.auto_create_config_file);
                       "failed to open the default configuration file");

    let bundle = tectonic::ctry!(config.default_bundle(option.only_cached, &mut status);
                       "failed to load the default resource bundle");

    let format_cache_path = tectonic::ctry!(config.format_cache_path();
                                  "failed to set up the format cache");

    let mut files = {
        // Looking forward to non-lexical lifetimes!
        let mut sb = tectonic::driver::ProcessingSessionBuilder::default();
        sb.bundle(bundle)
            .primary_input_buffer(latex.as_bytes())
            .tex_input_name("texput.tex")
            .format_name("latex")
            .format_cache_path(format_cache_path)
            .keep_logs(option.keep_logs)
            .keep_intermediates(option.keep_intermediates)
            .print_stdout(option.print_stdout)
            .output_format(tectonic::driver::OutputFormat::Pdf)
            .do_not_write_output_files();

        let mut sess =
            tectonic::ctry!(sb.create(&mut status); "failed to initialize the LaTeX processing session");
        tectonic::ctry!(sess.run(&mut status); "the LaTeX engine failed");
        sess.into_file_data()
    };

    match files.remove(std::ffi::OsStr::new("texput.pdf")) {
        Some(data) => Ok(data),
        None => Err(tectonic::errmsg!(
            "LaTeX didn't report failure, but no PDF was created (??)"
        )),
    }
}

ruby! {
    class LaTeXToPDFOption {
        struct {
            auto_create_config_file: bool, // false
            only_cached: bool, // false
            keep_logs: bool, // false
            keep_intermediates: bool, // false
            print_stdout: bool // false
        }
        def initialize(helix, auto_create_config_file: bool, only_cached: bool, keep_logs: bool, keep_intermediates: bool, print_stdout: bool) {
            LaTeXToPDFOption { 
                helix,
                auto_create_config_file: auto_create_config_file,
                only_cached: only_cached,
                keep_logs: keep_logs,
                keep_intermediates: keep_intermediates,
                print_stdout: print_stdout,
            }
        }
    }

    class BinData {
        struct {
            v32: Vec<u32>,
            len: usize
        }
        def initialize(helix, v32: Vec<u32>, len: usize) {
            BinData { helix, v32, len }
        }
        def capacity(&self) -> usize{
            self.len
        }
        def raw(&self) -> Vec<u32>{
            self.v32.clone()
        }
    }

    class TectonicRuby {
        def latex_to_pdf(latex: String, option: LaTeXToPDFOption) -> Option<BinData> {
            tectonic_latex_to_pdf(latex, option).ok().map(BinData::from)
        }
    }
}
