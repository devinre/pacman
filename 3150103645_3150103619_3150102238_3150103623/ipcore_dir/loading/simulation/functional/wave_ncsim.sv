

 
 
 

 



window new WaveWindow  -name  "Waves for BMG Example Design"
waveform  using  "Waves for BMG Example Design"

      waveform add -signals /loading_tb/status
      waveform add -signals /loading_tb/loading_synth_inst/bmg_port/CLKA
      waveform add -signals /loading_tb/loading_synth_inst/bmg_port/ADDRA
      waveform add -signals /loading_tb/loading_synth_inst/bmg_port/DINA
      waveform add -signals /loading_tb/loading_synth_inst/bmg_port/WEA
      waveform add -signals /loading_tb/loading_synth_inst/bmg_port/DOUTA

console submit -using simulator -wait no "run"
