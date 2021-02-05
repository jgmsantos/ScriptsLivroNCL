begin

f = addfile("../olr.jan2000.dez2009.nc","r")

olr = short2flt(f->olr)

printVarSummary(olr) ; [time | 120] x [lat | 73] x [lon | 144]
                     ; time: [1753152..1840080]
                     ; lat: [90..-90] => latitude de norte para sul.
                     ; lon: [ 0..357.5]

olrR = f2fsh_Wrap(olr(:,::-1,:),(/181,360/)) ; A latitude deve ser de sul para norte ("::-1").

printVarSummary(olrR) ; [time | 120] x [lat | 72] x [lon | 144]
                      ; time: [1753152..1840080]
                      ; lat: [-88.75..88.75] => latitude de sul para norte.
                      ; lon: [1.25..358.75]

wks = gsn_open_wks("pdf","ex01_f2fsh_Wrap_p2")

plot = new(2,graphic)
  
res                      = True
res@gsnDraw              = False           ; don't draw
res@gsnFrame             = False           ; don't advance frame
res@cnFillOn             = True            ; turn on color
res@cnFillMode           = "RasterFill"   
res@lbLabelBarOn         = False           ; turn off individual cb's
res@cnLinesOn            = False
res@gsnLeftString        = ""
res@gsnRightString       = ""
res@gsnCenterString      = ""
res@cnLinesOn            = False
res@cnLineLabelsOn       = False
res@cnLevelSelectionMode = "ExplicitLevels"
res@cnLevels             = ispan(140,300,10)

res@tiMainString         = "ROL - Grade original: regular 2.5~S~o~N~ x 2.5~S~o~N~"

plot(0) = gsn_csm_contour_map(wks,olr(0,:,:),res) 

res@tiMainString        = "ROL - Grade interpolada: regular 1.0~S~o~N~ x 1.0~S~o~N~"

plot(1) = gsn_csm_contour_map(wks,olrR(0,:,:),res) 

resP                    = True
resP@gsnPanelLabelBar   = True

gsn_panel(wks,plot,(/2,1/),resP)
end
