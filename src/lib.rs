#[macro_use]
extern crate helix;
extern crate tectonic;

impl From<Vec<u8>> for BinData {
    fn from(v8: Vec<u8>) -> BinData {
        let len = v8.capacity();
        let mut v32 = Vec::with_capacity(len / 4 + 1);
        for i in 0..(len / 4 + 1) {
            unsafe { 
                v32.push(std::mem::transmute::<[u8;4],u32>([
                    if i*4+0 >= len { 0u8 } else { v8[i*4+0] },
                    if i*4+1 >= len { 0u8 } else { v8[i*4+1] },
                    if i*4+2 >= len { 0u8 } else { v8[i*4+2] },
                    if i*4+3 >= len { 0u8 } else { v8[i*4+3] }
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
                let chunk = std::mem::transmute::<u32,[u8;4]>(v32[i]);
                if i*4+0 >= len { v8.push(chunk[i*4+0]) } 
                if i*4+1 >= len { v8.push(chunk[i*4+1]) }
                if i*4+2 >= len { v8.push(chunk[i*4+2]) }
                if i*4+3 >= len { v8.push(chunk[i*4+3]) }
            }
        }
        v8
    }
}

ruby! { 
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
        def latex_to_pdf(latex: String) -> Option<BinData> {
            tectonic::latex_to_pdf(latex).ok().map(BinData::from)
        }
    }
}
