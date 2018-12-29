#[macro_use]
extern crate helix;
extern crate tectonic;

ruby! { 
    class TectonicRuby {
        def latex_to_pdf(latex: String) -> Option<Vec<u64>> {
            match tectonic::latex_to_pdf(latex) {
                Ok(v8) => {
                    let len = v8.capacity();
                    let mut v64 = Vec::with_capacity(len / 64 + 1);
                    for i in 0..v64.capacity() {
                        unsafe{ 
                            v64.push(std::mem::transmute::<[u8;8],u64>([
                                if i*8+0 > len { 0 } else { v8[i*8+0] },
                                if i*8+1 > len { 0 } else { v8[i*8+1] },
                                if i*8+2 > len { 0 } else { v8[i*8+2] },
                                if i*8+3 > len { 0 } else { v8[i*8+3] },
                                if i*8+4 > len { 0 } else { v8[i*8+4] },
                                if i*8+5 > len { 0 } else { v8[i*8+5] },
                                if i*8+6 > len { 0 } else { v8[i*8+6] },
                                if i*8+7 > len { 0 } else { v8[i*8+7] },
                            ]));
                        }
                    }
                    Some(v64)
                },
                _ => None
            }
        }
    }
}
