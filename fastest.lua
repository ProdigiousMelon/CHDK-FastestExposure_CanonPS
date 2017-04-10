--[[
@title Lab 1 Fastest
@chdk_version 1.3
@param d exposure
@default d 4
--]]

function fastshoot()
	  press("shoot_half")
	  repeat 
		sleep(1)
	  until get_shooting() == true
	  log("shooting...")
	  press("shoot_full")
	  release("shoot_full")
	  release("shoot_half")
	  repeat
		sleep(1)
	  until get_shooting() ~= true
end
 
logfile=io.open("A/A/rawadd.log","wb")
io.output(logfile)
 
function log(...)
	io.write(...)
	io.write("\n")
end

function take_shot()
	for i=1,d do
		shoot()
		sleep(500)
		i = i + 1
	end
end
 
--set_iso_real(100)
set_tv96(1000)
 
log("Image directory:", get_image_dir(),"\n")
print("Image directory:", get_image_dir())
log("Exposure count:", get_exp_count(),"\n")
print("Exposure count:", get_exp_count())

--start taking exposures
take_shot()

ex=get_exp_count()--get exposures
imgOut=string.format('%s/SND_%04d.CRW',get_image_dir(),ex%10000)--set value for the imgOut
img = {}
jpg = {}



-- take series of exposures
for j=1,ex do--for every exposure, add it to the raw buffer
	s=j-1
	img[j]=string.format('%s/CRW_%04d.CRW',get_image_dir(),(ex-s)%10000)
	jpg[j]=string.format('%s/IMG_%04d.JPG',get_image_dir(),(ex-s)%10000)
end
-- sum exposures
log("raw_merge_start(0)","\n")
print("raw_merge_start(0)")
raw_merge_start(0)
	for exp_count=1,ex do
		raw_merge_add_file(img[exp_count])
		os.remove(jpg[exp_count])
	end
raw_merge_end()
	
log("Primary: raw_merge_end()" , "\n")

set_raw_develop(imgOut)
log("set_raw_develop(",imgOut,")","\n")
print("set_raw_develop(",imgOut,")")
fastshoot()

log("done!")
logfile:close()