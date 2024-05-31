///////////////////////////// Entry of quantification features /////////////////////////////
Dialog.create("!!!Warning!!!");
Dialog.addMessage("Please, make sure : \n- There are no spaces in the folder or file name!\n- \"Bio-formats\", \"Adjustable Watershed\" and \"3D object counter\" plugins are installed!\n- 8-bit Images are calibrated (in µm)");
Dialog.show();

Dialog.create("!!!Before using macro!!!");
Dialog.addMessage("You have to set several parameters before using the macro:\n");
Dialog.addMessage(" - DAPI adjustable watershed to separate nuclei,");//Adjustable watershed is able to separate badly segmented nuclei
Dialog.addMessage(" - DAPI threshold on AVG-z-projection (with Triangle),");//segmentation of nuclei with triangle threshold
Dialog.addMessage(" - DAPI threshold on z-sliced image (with Intermodes),");//segmentation of nuclei with Otsu threshold
Dialog.addMessage(" - Size of nucleus (min and max, in µm),");//size selection of nucleus
Dialog.addMessage(" - TASQ threshold on z-sliced image for nucleolus determination (with Yen),");//size selection of nucleus
Dialog.addMessage("- If cytoplasm analysis needed: \n* TASQ threshold (with Yen), \n* TASQ adjustable watershed to separate cytoplasm, \n* Size of cytoplasm (min and max, in µm),");//segmentation of TASQ foci with Yen threshold
Dialog.addMessage("- If foci determination needed: \n* TASQ threshold (with Triangle), \n* TASQ foci cut-off size (in voxel, corresponding to nucleoli staining).");//segmentation of TASQ foci with Yen threshold
Dialog.show();



///////// Selection of channel parameters
Dialog.create("Enter channels parameters");
Dialog.addNumber("DAPI channel number", 1);///value assignment for DAPI channel number
Dialog.addNumber("TASQ channel number", 2);///value assignment for TASQ channel number
Dialog.show();

Cdapi=Dialog.getNumber();///value assignment for DAPI channel number
Cgreen=Dialog.getNumber();///value assignment for TASQ channel number



///////// Define analysis to process
Dialog.create("Define which analysis to process");
Dialog.addMessage("Define which analysis to process (you can do both intensity and foci analysis):\n(Keep in mind that segmentation of cytoplasm is harder to do than one of nucleus, therefore you could obtain quantification for clusters of cells)");
Dialog.addCheckbox("Intensity analysis within nucleus ", false);
Dialog.addCheckbox("Foci analysis within nucleus ", false);
Dialog.addMessage("");
Dialog.addCheckbox("Intensity analysis within nucleus and cytoplasm ", false);
Dialog.addCheckbox("Foci analysis within nucleus and cytoplasm ", false);
Dialog.show();

Int=Dialog.getCheckbox();
Foci=Dialog.getCheckbox();
IntC=Dialog.getCheckbox();
FociC=Dialog.getCheckbox();



///////// Entry of quantification parameters 
Dialog.create("Enter quantification parameters");
Dialog.addMessage("Parameters common for all analyses:\n ");
Dialog.addNumber("z-DAPI Intermodes threshold", 21);///value assignment for zts
Dialog.addNumber("mask-z-DAPI watershed", 2);///value assignment for ws2
Dialog.addNumber("min. size of nucleus (µm)", 60);///value assignment for nmin
Dialog.addNumber("max. size of nucleus (µm)", 420);///value assignment for nmax
Dialog.addNumber("z-TASQ for nucleolus Yen threshold", 70);///value assignment for nts
Dialog.addNumber("segmentation of cytoplasm or TASQ background substraction (radius of filter mean)", 10);///value assignment for background substraction
if(Int || Foci){
	Dialog.addNumber("AVG-DAPI Triangle threshold", 12);///value assignment for dts
	Dialog.addNumber("AVG-DAPI watershed", 2);///value assignment for ws
}
if(IntC || FociC){
	Dialog.addMessage("Parameters for analysis within cytoplasm:\n ");
	Dialog.addNumber("AVG-TASQ Yen threshold", 8);///value assignment for yts
	Dialog.addNumber("AVG-DAPI Triangle threshold (in case nuclear TASQ signal is very low)", 12);///value assignment for dts
	Dialog.addNumber("AVG-TASQ watershed", 12);///value assignment for ws3
	Dialog.addNumber("min. size of cytoplasm (µm)", 100);///value assignment for cmin
	Dialog.addNumber("max. size of cytoplasm (µm)", 2000);///value assignment for cmax
	Dialog.addNumber("z-TASQ 3D gaussian blur for \"cytoplasmic\" segmentation x-y", 5);///value assignment for xGB
	Dialog.addNumber("z-TASQ 3D gaussian blur for \"cytoplasmic\" segmentation z", 2);///value assignment for zGB
	Dialog.addNumber("z-TASQ Yen threshold for cytoplasmic staining", 9);///value assignment for cts
	Dialog.addNumber("z-TASQ watershed for cytoplasmic staining", 5);///value assignment for ws4
}
if(Int || IntC){
	Dialog.addMessage("Parameters for nuclear foci analysis:\n ");
	Dialog.addNumber("Min. Voxel volume of nuclei", 5000);///value assignment for vnucleus
	Dialog.addNumber("Min. Voxel volume of nucleoli", 50);///value assignment for vnucleolus
}
if(IntC){
		Dialog.addNumber("Min. Voxel volume of cytoplasm", 10000);///value assignment for vcyto
	}
if(Foci || FociC){
	if(Foci){Dialog.addMessage("Parameters for nuclear foci analysis:\n ");}
	if(FociC){Dialog.addMessage("Parameters for nuclear and cytoplasmic foci analysis:\n ");}
	Dialog.addNumber("TASQ Triangle threshold for foci", 9);///value assignment for gts
	Dialog.addNumber("TASQ foci cut-off size (to exclude nucleoli, in voxels)", 50);///value assignment for cot
}
Dialog.show();


zts=Dialog.getNumber();///value of zDAPI threshold
ws2=Dialog.getNumber();///value of zDAPI watershed 
nmin=Dialog.getNumber();///value of size of nucleus (min)
nmax=Dialog.getNumber();///value of size of nucleus (max)
nts=Dialog.getNumber();///value of zTASQ threshold for nucleoli segmentation
r=Dialog.getNumber();///value of radius for background substraction
if(Int || Foci){
	dts=Dialog.getNumber();///value of AVG-DAPI threshold
	ws=Dialog.getNumber();///value of AVG-DAPI watershed 
}
if(IntC || FociC){
	yts=Dialog.getNumber();///value of TASQ threshold for z-projection
	dts=Dialog.getNumber();///value of AVG-DAPI threshold
	ws3=Dialog.getNumber();///value of TASQ cytoplasmic watershed 
	cmin=Dialog.getNumber();///value of size of cytoplasm (min)
	cmax=Dialog.getNumber();///value of size of cytoplasm (max)
	xGB=Dialog.getNumber();///value of x and y 3D Gaussian Blur
	zGB=Dialog.getNumber();///value of z 3D Gaussian Blur
	cts=Dialog.getNumber();///value of TASQ threshold
	ws4=Dialog.getNumber();///value of TASQ cytoplasmic watershed 
}
if(Int || IntC){
	vnucleus=Dialog.getNumber();///value of minimal voxel volume of nucleus
	vnucleolus=Dialog.getNumber();///value of minimal voxel volume of nucleolus
}
if(IntC){
	vcyto=Dialog.getNumber();///value of minimal voxel volume of cytoplasm
}
if(Foci || FociC){
	gts=Dialog.getNumber();///value of TASQ threshold
	cot=Dialog.getNumber();///value of cut-off TASQ
}




function sameParameters() { 
// allow to repeat over and over with same parameters


///////// Define directories
Dialog.create("Define directory to open images");
Dialog.addMessage("Choose directory to open images");
Dialog.show();
open_directory=getDirectory("Choose directory to open images");

Dialog.create("Define save directory");
Dialog.addMessage("Choose save directory");
Dialog.show();
save_directory=getDirectory("Choose save directory");


///////// Selection of images to process
Dialog.create("Enter the name of images and the number of images to process");
Dialog.addString("Enter the name of images: ", "name");//images from the same condition should have the same name
Dialog.addMessage("type extension of file (.tif, .lif, .vsi, .(...)),");
Dialog.addString("extension: ", ".tif");//name of extension
Dialog.addMessage("the number of images (series) to process,");
Dialog.addNumber("number: ", 2);//number of images with the same name

Dialog.show();

name= Dialog.getString();
ext= Dialog.getString();
i=Dialog.getNumber();


///////// Print of all parameters 
print("Name:", name);
print("Extension:", ext);
print("Number of images analyzed:", i);
print("Channels of cells:", "Channel DAPI: "+Cdapi, "Channel TASQ: "+Cgreen);
print("Size of nucleus:", nmin+"-"+nmax);
print("z-DAPI Intermodes threshold:", zts);
print("z-DAPI adjustable watershed:", ws2);
print("z-TASQ nucleoli Yen threshold:", nts);
if(Int || Foci){
print("AVG-projected DAPI Triangle threshold:", dts);
print("AVG-DAPI watershed #2:", ws);
}
if(IntC || FociC){
print("Size of cytoplasm:", cmin+"-"+cmax);
print("radius of mean filter for cytoplasm z-projection:", r);
print("AVG-TASQ Yen threshold for cytoplasmic staining:", yts);
print("AVG-cytoplasm separation watershed:", ws3);
print("Gaussian blurring for z-TASQ cytoplasmic determination:", "x="+xGB+" y="+xGB+" z="+zGB);
print("z-TASQ Yen threshold for cytoplasmic staining:", cts);
print("z-TASQ cytoplasmic separation watershed:", ws4);
}
if(Int || IntC){
print("Min. Voxel volume of nuclei:", vnucleus);
print("Min. Voxel volume of nucleoli:", vnucleolus);
}
if(IntC){
print("Min. Voxel volume of cytoplasm:", vcyto);
}
if(Foci || FociC){
print("radius of mean filter for TASQ backgound substraction:", r);
print("TASQ Triangle threshold for foci:", gts);
print("TASQ foci cut-off size:", cot);
}
if(Int){
	print("Results for intensity analysis as follow: image analysed (nuclear, nucleolar or nuclear w/o nucleoli)_#cell_#img, TASQ-MeanInt, sdMeanInt, nb ROI analyzed");
}
if(Foci){
	print("Results for foci analysis as follow: image analysed (small nuclear or large nuclear)_#cell_#img, foci-MeanVolume (in µm^3), sdMeanVol, nb of foci");
}
if(IntC){
	print("Results for intensity analysis as follow: image analysed (nuclear, nucleolar, nuclear w/o nucleoli or cytoplasmic)_#cell_#img, TASQ-MeanInt, sdMeanInt, nb ROI analyzed");
}
if(FociC){
	print("Results for foci analysis as follow: image analysed (small nuclear, large nuclear or cytoplasmic foci)_#cell_#img, foci-MeanVolume (in µm^3), sdMeanVol, nb of foci");
}


//Closing just in case...
if (isOpen("ROI Manager")) {
     selectWindow("ROI Manager");
     run("Close");
  }//close ROI Manager if open from previous session
if (isOpen("Results")) {
     selectWindow("Results");
     run("Close");
  }//close ROI Manager if open from previous session
  



///////////////////////////// Loop generation for quantification /////////////////////////////
for (k=1; k<=i; k++){
number=k;
img=name+number+ext;//image name, number and extension
path_img=open_directory+img;//path to open images

img_save=name+number+".tif";
path_img_save=save_directory+name+number+".tif";//save path for TIF image with all channels
path_DAPI_save=save_directory+name+"DAPI_"+number+".tif";//save path for quantified image of DAPI
path_green_save=save_directory+name+"TASQ_"+number+".tif";//save path for quantified image of TASQ staining


  
///////// Renaming and reslicing images determination
setForegroundColor(0, 0, 0);
setBackgroundColor(255, 255, 255);
run("Bio-Formats Importer", "open="+path_img+" color_mode=Composite rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT");
Stack.setPosition(Cdapi,11,1);
run("Channels Tool...");
run("Brightness/Contrast...");
run("Enhance Contrast", "saturated=0.35");
beep();
    title = "You can select z-stacks without blurring";
    msg = "Keep in mind lowest and highest z-values in focal plane, \nafter clicking \"OK\" a new box to enter these values will appear.\n(You can open \"Channels tool\" to see only DAPI staining)";
    waitForUser(title, msg);
//Selection of slices
s=getSliceNumber();
Dialog.create("Enter z-min and z-max for this image");
Dialog.addNumber("z min", 1);
Dialog.addNumber("z max: ", s);
Dialog.show();
zmin=Dialog.getNumber();
zmax=Dialog.getNumber();
bs=(zmin+zmax)/2;//important to estimate background with image

print("lowest z for img #"+number+":", zmin);
print("highest z for img #"+number+":", zmax);


///////// TASQ Background estimation
if (Int || IntC || FociC) {
Stack.setPosition(Cgreen,bs,1);
run("Duplicate...", "title=background.TIF");
setTool("rectangle");
b=3;
	for(a=0; a<b; a++) {
	makeRectangle(0, 0, 400, 400);
	beep();
    	title2 = "Selection of a zone for TASQ background detection";
    	msg2 = "Move rectangle to a zone without any cells (therefore without any TASQ staining)\nand then click on \"OK\" \n(If you have changed brightness and contrast be careful to not apply changes) \n(It is better if you keep the same slice for selection of background) \n \nYou have to do this three times";
    waitForUser(title2, msg2);
    roiManager("Add");
	run("Measure");
	selectWindow("Results");
	Background=getResult("Mean", 0);
	print("TASQ-background value for img #"+number+"_zone"+a+1+":", Background);
	run("Clear Results");
	}
	run("Select None");
	roiManager("Show All with labels");
	roiManager("Select", newArray(0,1,2));
	roiManager("Set Color", "white");
	roiManager("Set Line Width", 4);
	roiManager("Draw");
	selectWindow("background.TIF");
	saveAs("Tiff", save_directory+name+"background_"+number+".tif");
	close();
	roiManager("Deselect");
	roiManager("Delete");
run("Select None");

beep();
    	title2 = "Selection of mean TASQ background value";
    	msg2 = "Check on \"log\" window background value and keep in mind this mean background value, \nafter clicking \"OK\" a new box to enter this mean values will appear.";
    waitForUser(title2, msg2);
    //Selection of background value
Dialog.create("Enter mean background value for this image");
Dialog.addNumber("background value", 39);
Dialog.show();
bv=Dialog.getNumber();
print("background value to be substracted for img #"+number+":", bv);
}//end of loop for background determination for intensity analysis


///////// Splitting of channel in between determined slices
selectImage(img);
run("Duplicate...", "title=DAPI_"+number+".TIF duplicate channels="+Cdapi+" slices="+zmin+"-"+zmax);
selectImage(img);
run("Duplicate...", "title=TASQ_"+number+".TIF duplicate channels="+Cgreen+" slices="+zmin+"-"+zmax);
run("Subtract...", "value="+bv+" stack");
selectImage(img);
close(img);


///////// Thresholding of nuclei with DAPI image
selectWindow("DAPI_"+number+".TIF");
run("Duplicate...", "title=z-DAPI_"+number+".TIF duplicate");
run("Smooth", "stack");
	///Thresholding and converting to mask
	setAutoThreshold("Intermodes dark");
	setThreshold(zts, 255);
	run("Convert to Mask", "method=Intermodes background=Dark");
	run("Dilate", "stack");
	run("Dilate", "stack");
	run("Close-", "stack");
	run("Fill Holes", "stack");
	run("Erode", "stack");
	run("Erode", "stack");
	run("Erode", "stack");
	run("Erode", "stack");
	run("Adjustable Watershed", "tolerance="+ws2+" stack");
	run("Analyze Particles...", "size="+nmin+"-"+nmax+" show=Masks exclude stack");
	selectWindow("Mask of z-DAPI_"+number+".TIF");
	rename("Mask-DAPI_"+number+".TIF");
	selectWindow("z-DAPI_"+number+".TIF");
	close();
	
	///Thresholding nucleolus staining with TASQ image
if(Int || IntC){
	selectWindow("TASQ_"+number+".TIF");
	run("Duplicate...", "title=nucleoli_"+number+".TIF duplicate");
	run("Smooth", "stack");
	setAutoThreshold("Yen dark");
	setThreshold(nts, 255);
	run("Convert to Mask", "method=Yen background=Dark");
	rename("Mask-nucleoli_"+number+".TIF");
	imageCalculator("AND stack", "Mask-nucleoli_"+number+".TIF","Mask-DAPI_"+number+".TIF");
	//creation of DAPI without nucleoli mask
	selectWindow("Mask-DAPI_"+number+".TIF");
	run("Duplicate...", "title=Mask-DAPI-wo-nucleoli_"+number+".TIF duplicate");
	imageCalculator("Subtract stack", "Mask-DAPI-wo-nucleoli_"+number+".TIF","Mask-nucleoli_"+number+".TIF");
}//end of loop for mask creation for nucleoli and nuclei without nucleoli


///////// Thresholding cytoplasmic TASQ staining with green image before background removal
if(IntC || FociC){
	// Z-projection of cytoplasm and selection of ROI
	selectWindow("TASQ_"+number+".TIF");
	run("Duplicate...", "title=blurred-TASQ_"+number+".TIF duplicate");
	run("Mean...", "radius="+r+" stack");
	run("Z Project...", "projection=[Average Intensity]");
	rename("AVG-TASQ_"+number+".TIF");
		if (FociC==0) {
		close("blurred-TASQ_"+number+".TIF");
		}//closing of blurred TASQ image if FociC condition is false
	setAutoThreshold("Yen dark");
	setThreshold(yts, 255);
	run("Convert to Mask");
	selectWindow("DAPI_"+number+".TIF");
	run("Z Project...", "projection=[Average Intensity]");
	rename("AVG-DAPI_"+number+".TIF");
	run("Smooth");
	setAutoThreshold("Triangle dark");
	setThreshold(dts, 255);
	run("Convert to Mask");
	run("Close-");
	run("Fill Holes");
	run("Dilate");
	run("Dilate");
	imageCalculator("Add stack", "AVG-TASQ_"+number+".TIF","AVG-DAPI_"+number+".TIF");
	run("Adjustable Watershed", "tolerance="+ws3);
	run("Analyze Particles...", "size="+cmin+"-"+cmax+" show=Nothing exclude clear add");

		// Save of ROI determination images
		selectImage("AVG-TASQ_"+number+".TIF");
		saveAs("Tiff", save_directory+name+"cytoTASQ-zproj_"+number+".tif");
		close();
		selectImage("AVG-DAPI_"+number+".TIF");
		close();
	
	//creation of whole cell mask
	selectWindow("TASQ_"+number+".TIF");
	run("Duplicate...", "title=cyto-TASQ_"+number+".TIF duplicate");
	selectWindow("cyto-TASQ_"+number+".TIF");
	run("Gaussian Blur 3D...", "x="+xGB+" y="+xGB+" z="+zGB);
	setAutoThreshold("Yen dark");
	setThreshold(cts, 255);
	run("Convert to Mask", "method=Yen background=Dark");
	imageCalculator("Add stack", "cyto-TASQ_"+number+".TIF","Mask-DAPI_"+number+".TIF");
	run("Adjustable Watershed", "tolerance="+ws4+" stack");
	selectWindow("cyto-TASQ_"+number+".TIF");
	run("Analyze Particles...", "size="+cmin+"-"+cmax+" show=Masks exclude stack");
	rename("Mask-cytoTASQ_"+number+".TIF");
	selectImage("cyto-TASQ_"+number+".TIF");
	close();
	
	//creation of cytoplasm only
	selectWindow("Mask-cytoTASQ_"+number+".TIF");
	imageCalculator("Subtract stack", "Mask-cytoTASQ_"+number+".TIF","Mask-DAPI_"+number+".TIF");
}//end of loop for ROI selection of cytoplasm only


///////// Thresholding nuclear DAPI staining
if(Int || Foci){	
	// Z-projection of nucleus and selection of ROI
	selectWindow("DAPI_"+number+".TIF");
	run("Z Project...", "projection=[Average Intensity]");
	rename("AVG-DAPI_"+number+".TIF");
	run("Smooth");
	setAutoThreshold("Triangle dark");
	setThreshold(dts, 255);
	run("Convert to Mask");
	run("Close-");
	run("Fill Holes");
	run("Erode");
	run("Dilate");
	run("Dilate");
	run("Adjustable Watershed", "tolerance="+ws);
	run("Analyze Particles...", "size="+nmin+"-"+nmax+" show=Nothing exclude clear add");
	
		// Save of ROI determination images	
		selectImage("AVG-DAPI_"+number+".TIF");
		saveAs("Tiff", save_directory+name+"DAPI-zproj_"+number+".tif");
		close();
}//end of loop for ROI selection of nuclei only


///////// Background removal of TASQ staining with green image and creation of foci masks
if(Foci || FociC){
	// Thresholding and converting to mask
	if (Foci==1) {
		selectWindow("TASQ_"+number+".TIF");
		run("Duplicate...", "title=blurred-TASQ_"+number+".TIF duplicate");
		run("Mean...", "radius="+r+" stack");
		}//end of loop for creation of blurred TASQ image if Foci condition is true
	selectWindow("TASQ_"+number+".TIF");
	run("Duplicate...", "title=foci-TASQ_"+number+".TIF duplicate");
	imageCalculator("Subtract stack", "foci-TASQ_"+number+".TIF","blurred-TASQ_"+number+".TIF");
	selectWindow("blurred-TASQ_"+number+".TIF");
	close();
	selectWindow("foci-TASQ_"+number+".TIF");
	setAutoThreshold("Triangle dark");
	setThreshold(gts, 255);
	run("Convert to Mask", "method=Triangle background=Dark");
	
	// Creation of nuclear mask for foci detectermination
	selectWindow("foci-TASQ_"+number+".TIF");
	run("Duplicate...", "title=nuclear-foci-TASQ_"+number+".TIF duplicate");
	imageCalculator("AND stack", "nuclear-foci-TASQ_"+number+".TIF","Mask-DAPI_"+number+".TIF");
	
	if(FociC){
		// Creation of nuclear mask for foci detectermination
		selectWindow("foci-TASQ_"+number+".TIF");
		run("Duplicate...", "title=cyto-foci-TASQ_"+number+".TIF duplicate");
		imageCalculator("AND stack", "cyto-foci-TASQ_"+number+".TIF","Mask-cytoTASQ_"+number+".TIF");
	}//end of loop for cytoplasmic foci
	
		// Save of ROI determination images	
		selectWindow("foci-TASQ_"+number+".TIF");
		saveAs("Tiff", save_directory+name+"foci-TASQ_"+number+".tif");
		close();
	}//end of loop for foci segmentation
	
	




///////// Loop to quantify TASQ intensity or foci
for(c=0;c<roiManager("count");c++){
	
	if(Int || IntC){
	/// Loop to quantify intensity of TASQ
		run("3D OC Options", "volume nb_of_obj._voxels mean_gray_value std_dev_gray_value dots_size=5 font_size=10 redirect_to=TASQ_"+c+1+"/"+number+"");
		selectWindow("TASQ_"+number+".TIF");
		roiManager("Select",c);//selection of nucleus from ROI manager
		run("Duplicate...", "title=TASQ_"+c+1+"/"+number+" duplicate range=stack");//duplication of ROI and renaming for quantification of TASQ intensity
		/// within nucleus
		run("Clear Results");
		selectWindow("Mask-DAPI_"+number+".TIF");
		roiManager("Select",c);//selection of nucleus from ROI manager
		run("Duplicate...", "title=Mask-DAPI_"+c+1+"/"+number+" duplicate range=stack");//duplication of ROI and renaming for quantification of TASQ intensity
		run("Clear Outside", "stack");//clear outside the ROI
		selectWindow("Mask-DAPI_"+c+1+"/"+number);
		run("3D Objects Counter", "threshold=0 slice=1 min.="+vnucleus+" max.=2000000 objects statistics");
		selectWindow("Results");
		if(nResults>1){
			run("Summarize");
		}
		selectWindow("Results");
		n=nResults();
			//Getting mean and sd results
			if(n==0){
				print("nuclear-TASQ-int_cell#"+c+1+"_"+number+", 0, 0, 0");
			}//end of loop for none result
			if(n==1){
				meanNormInt=getResult("Mean", 0);
				sdNormInt=getResult("StdDev", 0);
				print("nuclear-TASQ-int_cell#"+c+1+"_"+number+", "+meanNormInt+", "+sdNormInt+", "+n);
			}//end of loop for results n=1
			if(n>1) {
			for(j=0; j<n; j++) {
    		Label=getResultString("Label", j);
    			if(Label=="Mean"){
    			meanNormInt=getResult("Mean", j);
    			}//end of loop for mean results
    			if(Label=="SD"){
    			sdNormInt=getResult("Mean", j);
    			}//end of loop for sd results
    			}//end of loop to get results
    			print("nuclear-TASQ-int_cell#"+c+1+"_"+number+", "+meanNormInt+", "+sdNormInt+", "+n-4);
			}//end of loop for n results
			run("Clear Results");
			close("Objects map of Mask-DAPI_"+c+1+"/"+number+" redirect to TASQ_"+c+1+"/"+number+"");
			close("Mask-DAPI_"+c+1+"/"+number);
		
		/// within nucleolus
		run("3D OC Options", "volume nb_of_obj._voxels mean_gray_value std_dev_gray_value dots_size=5 font_size=10 redirect_to=TASQ_"+c+1+"/"+number+"");
		run("Clear Results");
		selectWindow("Mask-nucleoli_"+number+".TIF");
		roiManager("Select",c);//selection of nucleus from ROI manager
		run("Duplicate...", "title=Mask-nucleoli_"+c+1+"/"+number+" duplicate range=stack");//duplication of ROI and renaming for quantification of TASQ intensity
		run("Clear Outside", "stack");//clear outside the ROI
		selectWindow("Mask-nucleoli_"+c+1+"/"+number);
		run("3D Objects Counter", "threshold=0 slice=1 min.="+vnucleolus+" max.=2000000 objects statistics");
		selectWindow("Results");
		if(nResults>1){
			run("Summarize");
		}
		selectWindow("Results");
		n=nResults();
			//Getting mean and sd results
			if(n==0){
				print("nucleolar-TASQ-int_cell#"+c+1+"_"+number+", 0, 0, 0");
			}//end of loop for none result
			if(n==1){
				meanNormInt=getResult("Mean", 0);
				sdNormInt=getResult("StdDev", 0);
				print("nucleolar-TASQ-int_cell#"+c+1+"_"+number+", "+meanNormInt+", "+sdNormInt+", "+n);
			}//end of loop for results n=1
			if(n>1) {
			for(j=0; j<n; j++) {
    		Label=getResultString("Label", j);
    			if(Label=="Mean"){
    			meanNormInt=getResult("Mean", j);
    			}//end of loop for mean results
    			if(Label=="SD"){
    			sdNormInt=getResult("Mean", j);
    			}//end of loop for sd results
    			}//end of loop to get results
    			print("nucleolar-TASQ-int_cell#"+c+1+"_"+number+", "+meanNormInt+", "+sdNormInt+", "+n-4);
			}//end of loop for n results
			run("Clear Results");
			close("Objects map of Mask-nucleoli_"+c+1+"/"+number+" redirect to TASQ_"+c+1+"/"+number+"");
			close("Mask-nucleoli_"+c+1+"/"+number);
		
		/// within nucleus without nucleolus staining
		run("3D OC Options", "volume nb_of_obj._voxels mean_gray_value std_dev_gray_value dots_size=5 font_size=10 redirect_to=TASQ_"+c+1+"/"+number+"");
		run("Clear Results");
		selectWindow("Mask-DAPI-wo-nucleoli_"+number+".TIF");
		roiManager("Select",c);//selection of nucleus from ROI manager
		run("Duplicate...", "title=Mask-DAPI-wo-nucleoli_"+c+1+"/"+number+" duplicate range=stack");//duplication of ROI and renaming for quantification of TASQ intensity
		run("Clear Outside", "stack");//clear outside the ROI
		selectWindow("Mask-DAPI-wo-nucleoli_"+c+1+"/"+number);
		run("3D Objects Counter", "threshold=0 slice=1 min.="+vnucleus+" max.=2000000 objects statistics");
		selectWindow("Results");
		if(nResults>1){
			run("Summarize");
		}
		selectWindow("Results");
		n=nResults();
			//Getting mean and sd results
			if(n==0){
				print("nuclear-wo-nucleolar-TASQ-int_cell#"+c+1+"_"+number+", 0, 0, 0");
			}//end of loop for none result
			if(n==1){
				meanNormInt=getResult("Mean", 0);
				sdNormInt=getResult("StdDev", 0);
				print("nuclear-wo-nucleolar-TASQ-int_cell#"+c+1+"_"+number+", "+meanNormInt+", "+sdNormInt+", "+n);
			}//end of loop for results n=1
			if(n>1) {
			for(j=0; j<n; j++) {
    		Label=getResultString("Label", j);
    			if(Label=="Mean"){
    			meanNormInt=getResult("Mean", j);
    			}//end of loop for mean results
    			if(Label=="SD"){
    			sdNormInt=getResult("Mean", j);
    			}//end of loop for sd results
    			}//end of loop to get results
			print("nuclear-wo-nucleolar-TASQ-int_cell#"+c+1+"_"+number+", "+meanNormInt+", "+sdNormInt+", "+n-4);
			}//end of loop for n results
			run("Clear Results");
			close("Objects map of Mask-DAPI-wo-nucleoli_"+c+1+"/"+number+" redirect to TASQ_"+c+1+"/"+number+"");
			close("Mask-DAPI-wo-nucleoli_"+c+1+"/"+number);
		
		if(IntC){
		/// within cytoplasm
		run("3D OC Options", "volume nb_of_obj._voxels mean_gray_value std_dev_gray_value dots_size=5 font_size=10 redirect_to=TASQ_"+c+1+"/"+number+"");
		run("Clear Results");
		selectWindow("Mask-cytoTASQ_"+number+".TIF");
		roiManager("Select",c);//selection of nucleus from ROI manager
		run("Duplicate...", "title=Mask-cytoTASQ_"+c+1+"/"+number+" duplicate range=stack");//duplication of ROI and renaming for quantification of TASQ intensity
		run("Clear Outside", "stack");//clear outside the ROI
		selectWindow("Mask-cytoTASQ_"+c+1+"/"+number);
		run("3D Objects Counter", "threshold=0 slice=1 min.="+vcyto+" max.=2000000 objects statistics");
		selectWindow("Results");
		if(nResults>1){
			run("Summarize");
		}
		selectWindow("Results");
		n=nResults();
			//Getting mean and sd results
			if(n==0){
				print("cytoplasmic-TASQ-int_cell#"+c+1+"_"+number+", 0, 0, 0");
			}//end of loop for none result
			if(n==1){
				meanNormInt=getResult("Mean", 0);
				sdNormInt=getResult("StdDev", 0);
				print("cytoplasmic-TASQ-int_cell#"+c+1+"_"+number+", "+meanNormInt+", "+sdNormInt+", "+n);
			}//end of loop for results n=1
			if(n>1) {
			for(j=0; j<n; j++) {
    		Label=getResultString("Label", j);
    			if(Label=="Mean"){
    			meanNormInt=getResult("Mean", j);
    			}//end of loop for mean results
    			if(Label=="SD"){
    			sdNormInt=getResult("Mean", j);
    			}//end of loop for sd results
    			}//end of loop to get results
			print("cytoplasmic-TASQ-int_cell#"+c+1+"_"+number+", "+meanNormInt+", "+sdNormInt+", "+n-4);
			}//end of loop for n results
			run("Clear Results");
			close("Objects map of Mask-cytoTASQ_"+c+1+"/"+number+" redirect to TASQ_"+c+1+"/"+number+"");
			close("Mask-cytoTASQ_"+c+1+"/"+number);
		}//end of loop for cytoplasmic intensity analysis
		close("TASQ_"+c+1+"/"+number);
}//end of intensity loop

	if(Foci || FociC){
	/// Loop to quantify TASQ foci
		/// within nucleus 
		run("3D OC Options", "volume nb_of_obj._voxels mean_gray_value std_dev_gray_value dots_size=5 font_size=10 redirect_to=none");
		selectWindow("nuclear-foci-TASQ_"+number+".TIF");
		roiManager("Select",c);//selection of nucleus from ROI manager
		run("Duplicate...", "title=nuclear-foci-TASQ_"+c+1+"/"+number+" duplicate range=stack");//duplication of ROI and renaming for quantification of nuclear TASQ foci
		run("Clear Outside", "stack");//clear outside the ROI
		
		/// within nucleus (small foci)
		run("Clear Results");
		selectWindow("nuclear-foci-TASQ_"+c+1+"/"+number);
		run("3D Objects Counter", "threshold=0 slice=1 min.=3 max.="+cot+" objects statistics");
		selectWindow("Results");
		if(nResults>1){
			run("Summarize");
		}
		selectWindow("Results");
		n=nResults();
			//Getting mean and sd results
			if(n==0){
				print("small(≤"+cot+" voxels)-nuclear-foci-TASQ_cell#"+c+1+"_"+number+", 0, 0, 0");
			}//end of loop for none result
			if(n==1){
				meanVol=getResult("Volume (micron^3)", 0);
				print("small(≤"+cot+" voxels)-nuclear-foci-TASQ_cell#"+c+1+"_"+number+", "+meanVol+", 0, "+n);
			}//end of loop for results n=1
			if(n>1) {
			for(j=0; j<n; j++) {
    		Label=getResultString("Label", j);
    			if(Label=="Mean"){
    			meanVol=getResult("Volume (micron^3)", j);
    			}//end of loop for mean results
    			if(Label=="SD"){
    			sdVol=getResult("Volume (micron^3)", j);
    			}//end of loop for sd results
    			}//end of loop to get results
			print("small(≤"+cot+" voxels)-nuclear-foci-TASQ_cell#"+c+1+"_"+number+", "+meanVol+", "+sdVol+", "+n-4);
			}//end of loop for n results
			run("Clear Results");
			close("Objects map of nuclear-foci-TASQ_"+c+1+"/"+number);
			
		/// within nucleus (large foci)
		run("Clear Results");
		selectWindow("nuclear-foci-TASQ_"+c+1+"/"+number);
		run("3D Objects Counter", "threshold=0 slice=1 min.="+cot+1+" max.=2000000 objects statistics");
		selectWindow("Results");
		if(nResults>1){
			run("Summarize");
		}
		selectWindow("Results");
		n=nResults();
			//Getting mean and sd results
			if(n==0){
				print("large(>"+cot+" voxels)-nuclear-foci-TASQ_cell#"+c+1+"_"+number+", 0, 0, 0");
			}//end of loop for none result
			if(n==1){
				meanVol=getResult("Volume (micron^3)", 0);
				print("large(>"+cot+" voxels)-nuclear-foci-TASQ_cell#"+c+1+"_"+number+", "+meanVol+", 0, "+n);
			}//end of loop for results n=1
			if(n>1) {
			for(j=0; j<n; j++) {
    		Label=getResultString("Label", j);
    			if(Label=="Mean"){
    			meanVol=getResult("Volume (micron^3)", j);
    			}//end of loop for mean results
    			if(Label=="SD"){
    			sdVol=getResult("Volume (micron^3)", j);
    			}//end of loop for sd results
    			}//end of loop to get results
			print("large(>"+cot+" voxels)-nuclear-foci-TASQ_cell#"+c+1+"_"+number+", "+meanVol+", "+sdVol+", "+n-4);
			}//end of loop for n results
			run("Clear Results");
			close("Objects map of nuclear-foci-TASQ_"+c+1+"/"+number);
			close("nuclear-foci-TASQ_"+c+1+"/"+number);
			
		if(FociC){
			/// within cytoplasm
			run("Clear Results");
			selectWindow("cyto-foci-TASQ_"+number+".TIF");
			roiManager("Select",c);//selection of nucleus from ROI manager
			run("Duplicate...", "title=cyto-foci-TASQ_"+c+1+"/"+number+" duplicate range=stack");//duplication of ROI and renaming for quantification of nuclear TASQ foci
			run("Clear Outside", "stack");//clear outside the ROI
			selectWindow("cyto-foci-TASQ_"+c+1+"/"+number);
			run("3D Objects Counter", "threshold=0 slice=1 min.=3 max.=2000000 objects statistics");
			selectWindow("Results");
			if(nResults>1){
				run("Summarize");
			}
			selectWindow("Results");
			n=nResults();
				//Getting mean and sd results
				if(n==0){
					print("cytoplasmic-foci-TASQ_cell#"+c+1+"_"+number+", 0, 0, 0");
				}//end of loop for none result
				if(n==1){
					meanVol=getResult("Volume (micron^3)", 0);
					print("cytoplasmic-foci-TASQ_cell#"+c+1+"_"+number+", "+meanVol+", 0, "+n);
				}//end of loop for results n=1
				if(n>1) {
				for(j=0; j<n; j++) {
    			Label=getResultString("Label", j);
    				if(Label=="Mean"){
    				meanVol=getResult("Volume (micron^3)", j);
    				}//end of loop for mean results
    				if(Label=="SD"){
    				sdVol=getResult("Volume (micron^3)", j);
    				}//end of loop for sd results
    				}//end of loop to get results
				print("cytoplasmic-foci-TASQ_cell#"+c+1+"_"+number+", "+meanVol+", "+sdVol+", "+n-4);
				}//end of loop for n results
				run("Clear Results");
				close("Objects map of cyto-foci-TASQ_"+c+1+"/"+number);
				close("cyto-foci-TASQ_"+c+1+"/"+number);
		}//end of loop for cytoplasmic foci quantification
}//end of loop foci quantification

}//end of ROI manager loop
roiManager("deselect");
roiManager("Delete");


///////// Save of images and results TASQ intensity and/or foci per images
	//Save of DAPI and TASQ unmodified images
selectWindow("DAPI_"+number+".TIF");
saveAs("Tiff", path_DAPI_save);
selectWindow("TASQ_"+number+".TIF");
saveAs("Tiff", path_green_save);

	//Save mask images for intensity analysis
if(Int || IntC){
	selectWindow("Mask-DAPI_"+number+".TIF");
	saveAs("Tiff", save_directory+name+"mask-DAPI_"+number+".TIF");
	selectWindow("Mask-nucleoli_"+number+".TIF");
	saveAs("Tiff", save_directory+name+"mask-nucleoli_"+number+".TIF");
	selectWindow("Mask-DAPI-wo-nucleoli_"+number+".TIF");
	saveAs("Tiff", save_directory+name+"mask-DAPI-wo-nucleoli_"+number+".TIF");
if(IntC){
	selectWindow("Mask-cytoTASQ_"+number+".TIF");
	saveAs("Tiff", save_directory+name+"mask-cyto-TASQ_"+number+".TIF");
}//end of saving if IntC is true
}//end of loop if intensities (Int or IntC) are quantified

	//Save TASQ images for foci quantification
if(Foci || FociC){
	selectWindow("nuclear-foci-TASQ_"+number+".TIF");
	saveAs("Tiff", save_directory+name+"nuclear-foci-TASQ_"+number+".TIF");
	if(FociC){
		selectWindow("cyto-foci-TASQ_"+number+".TIF");
		saveAs("Tiff", save_directory+name+"cyto-foci-TASQ_"+number+".TIF");
	}//end of saving if FociC is true
}//end of loop if foci (Foci or FociC) are quantified

	//Close of all images
close("*");


}//end of loop for each image to be opened




///////////////////////////// Save all quantification /////////////////////////////
selectWindow("Log");
saveAs("text",save_directory+"all-results-for-all-images-of_"+name+".txt");//Save all types of quantification for all images
run("Clear Results");
run("Close");
close("*");



///////////////////////////// Message box for macro restarting /////////////////////////////
messa= getBoolean("Do you have other images to analyze?");
Dialog.addMessage("!!!Macro will work with same parameters!!!");
if (messa==1){
//run function
sameParameters();
}//end of loop for same macro
else if (messa==0) {
exit;
}//enf of loop for no use of this macro
}//end of function "sameParameters"



sameParameters();

