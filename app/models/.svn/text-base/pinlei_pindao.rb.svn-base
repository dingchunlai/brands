class PinleiPindao < Hejia::Db::Hejia
  set_table_name "pinlei_pindaos"

  def pindao_keywords
    #[self.html_keywords.split(","),self.lm1_kw,self.lm2_kw,self.lm3_kw,self.lm4_kw,self.lm5_kw].flatten.uniq
    [self.lm1_kw,self.lm2_kw,self.lm3_kw,self.lm4_kw,self.lm5_kw].flatten.uniq
  end
end
