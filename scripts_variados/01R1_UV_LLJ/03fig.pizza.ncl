load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shapefile_utils.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/contrib/time_axis_labels.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/esmf/ESMF_regridding.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/contrib/acentos.ncl"
load "/usr/local/ncarg/lib/ncarg/nclscripts/csm/contributed.ncl_640.ncl"

begin

fin  = "jbn.datas.txt"  ; Arquivo com as datas que ocorreram os JBNs. 
nlin = numAsciiRow(fin) ; Número de linhas do arquivo acima.
ncol = numAsciiCol(fin) ; Número de colunas do arquivo acima.

atxt = asciiread(fin,(/nlin,ncol/),"integer") ; Abertura do arquixo texto.

i  = atxt(:,1)                      ; Tipo inteiro.
k1  = str_get_cols(tostring(i),8,9) ; A variável "i" precisar ser 
                                    ; do tipo string e não inteiro.

k2  = str_get_cols(tostring(i),9,9) ; A variável "i" precisar ser 
                                    ; do tipo string e não inteiro.

total00 = num(k2.eq.0)  ; Conta o total de JBN às 00UTC
total06 = num(k2.eq.6)  ; Conta o total de JBN às 06UTC
total12 = num(k1.eq.12) ; Conta o total de JBN às 12UTC
total18 = num(k1.eq.18) ; Conta o total de JBN às 18UTC

total = dimsizes(k1)    ; Total de JBN. Poderia utilizar o k2.

x      = new((/4,1/),"float")
x(0,:) = (total00*100.)/total
x(1,:) = (total06*100.)/total
x(2,:) = (total12*100.)/total
x(3,:) = (total18*100.)/total

hora = (/"0000UTC","0600UTC","1200UTC","1800UTC"/)
cor  = (/"red","wheat","orange","yellow"/)

wks = gsn_open_wks("pdf","fig.pizza")

pcRes              = True
pcRes@gsnMaximize  = True
pcRes@tiMainString = "Porcentagem de JBN por hora ~C~" +\+ 
                     "     Santa Cruz de La Sierra"
pcRes@pcLabelType  = "block"

plot = pie_chart(wks,x(:,0),hora,cor,pcRes)

end
