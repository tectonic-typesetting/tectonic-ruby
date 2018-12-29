#[macro_use]
extern crate helix;
extern crate tectonic;

ruby! { 
    class TectonicRuby {
        def latex_to_pdf(latex: String) -> Option<Vec<u32>> {
            match tectonic::latex_to_pdf(latex) {
                Ok(v8) => {
                    let len = v8.capacity();
                    let mut v32 = Vec::with_capacity(len / 4 + 1);
                    for i in 0..(len / 4 + 1) {
                        unsafe{ 
                            v32.push(std::mem::transmute::<[u8;4],u32>([
                                if i*4+0 >= len { 0u8 } else { v8[i*4+0] },
                                if i*4+1 >= len { 0u8 } else { v8[i*4+1] },
                                if i*4+2 >= len { 0u8 } else { v8[i*4+2] },
                                if i*4+3 >= len { 0u8 } else { v8[i*4+3] },
                            ]));
                        }
                    }
                    Some(v32)
                },
                _ => None
            }
        }
    }
}
