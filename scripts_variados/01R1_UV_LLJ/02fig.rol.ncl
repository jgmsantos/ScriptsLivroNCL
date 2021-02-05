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

i  = atxt(:,1)                     ; Tipo inteiro.
k  = str_get_cols(tostring(i),0,7) ; A variável "i" precisar ser 
                                   ; do tipo string e não inteiro.
ji  = get_unique_union(k,k)        ; Tipo string. Exclui os dias que se repetem.

f = addfile("rol.NDJF.1975.2000.nc","r") ; Abertura do arquivo netCDF de ROL.

time     = f->time
AAAAMMDD = cd_calendar(time,-2)

t = get1Dindex(AAAAMMDD,ji)            ; Obtém o índice de cada ano de AAAAMMDD.

rol_JNB  = short2flt(f->olr(t,:,:))    ; Leitura do dado COM JBN.
rol_JBNm = dim_avg_n_Wrap(rol_JNB,0)   ; Média na dimensão tempo (0).

rol_SJNB  = short2flt(f->olr)          ; Leitura do dado SEM JBN.
rol_SJBNm = dim_avg_n_Wrap(rol_SJNB,0) ; Média na dimensão tempo (0).

dif = rol_JBNm - rol_SJBNm             ; Calcula a diferença.

copy_VarCoords(rol_SJBNm,dif)

plot = new(3,graphic)

wks = gsn_open_wks("pdf","fig.rol")

res                       = True
res@gsnDraw               = False
res@gsnFrame              = False
res@cnFillOn              = True
res@cnFillMode            = "RasterFill"   
res@gsnLeftString         = ""
res@gsnRightString        = ""
res@cnLineLabelsOn        = False
res@mpMinLatF             = -40.0
res@mpMaxLatF             =  15.0
res@mpMinLonF             = -90.0
res@mpMaxLonF             = -30.0
res@lbLabelBarOn          = True
res@cnLevelSelectionMode  = "ExplicitLevels"
res@cnLevels              = ispan(200,280,10)
res@cnLinesOn             = False
res@mpOutlineBoundarySets = "National"
res@mpDataSetName         = "Earth..4"
res@mpDataBaseVersion     = "MediumRes"
res@mpOutlineSpecifiers   = (/"Brazil:states"/)
res@gsnMajorLonSpacing    = 10
res@gsnMajorLatSpacing    = 5
res@tmYLMinorOn           = False
res@tmXBMinorOn           = False

res@gsnCenterString       = "ROL NDJF (W m~S~2~N~) - SEM JBN"

plot(0) = gsn_csm_contour_map_ce(wks,rol_SJBNm,res) ; Plot SEM JBN.

res@gsnCenterString       = "ROL NDJF (W m~S~2~N~) - COM JBN"

plot(1) = gsn_csm_contour_map_ce(wks,rol_JBNm,res) ; Plot COM JBN. 

res@gsnCenterString       = "Anomalia de ROL NDJF (COM JBN-SEM JBN)"
res@cnLevelSelectionMode  = "ExplicitLevels"
res@cnLevels             := (/-25,-20,-15,-10,-5,0,5,10/)
res@cnFillColors          = (/2,3,4,5,6,9,9,14,16/) 
res@cnFillPalette         = "temp_diff_18lev"

plot(2) = gsn_csm_contour_map_ce(wks,dif,res) ; Plot da diferença. 

pres                               = True
pres@gsnPanelFigureStrings         = (/"a)","b)","c)"/)
pres@gsnPanelFigureStringsPerimOn  = False
pres@amJust                        = "TopRight"

gsn_panel(wks,plot,(/2,2/),pres)

end
