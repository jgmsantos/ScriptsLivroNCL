; Nome do script: cap14_ex23.ncl

begin

f = addfile("../../dados/gpcp.mensal.1979.2012.nc","r")

ppt = f->precip ; float precip ( time, lat, lon )
                ; [time | 408] x [lat | 72] x [lon | 144]
                ; Dado mensal de precipitação.

xSumTime = dim_sum_n_Wrap(ppt,0) ; Calcula a soma 
                                 ; na dimensão tempo (0).

; Dimensions and sizes: [lat | 72] x [lon | 144]
printVarSummary(xSumTime) 

end
