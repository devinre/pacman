

 
 
 

 



window new WaveWindow  -name  "Waves for BMG Example Design"
waveform  using  "Waves for BMG Example Design"

      waveform add -signals /zhuanqiang_400_280_tb/status
      waveform add -signals /zhuanqiang_400_280_tb/zhuanqiang_400_280_synth_inst/bmg_port/CLKA
      waveform add -signals /zhuanqiang_400_280_tb/zhuanqiang_400_280_synth_inst/bmg_port/ADDRA
      waveform add -signals /zhuanqiang_400_280_tb/zhuanqiang_400_280_synth_inst/bmg_port/DINA
      waveform add -signals /zhuanqiang_400_280_tb/zhuanqiang_400_280_synth_inst/bmg_port/WEA
      waveform add -signals /zhuanqiang_400_280_tb/zhuanqiang_400_280_synth_inst/bmg_port/DOUTA

console submit -using simulator -wait no "run"
