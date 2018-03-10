function[H,inlierIndices]=estimate_homography(img1Features,img2Features)
	parameters.numIterations=150;
	parameters.subsetSize=4;
	parameters.inlierDistThreshold=10;
	parameters.minInlierRatio= .3;
	[H,inlierIndices]=ransac_H(parameters,img1Features,img2Features,@fit_homography,@calc_residuals);
	display('Number of inliers');
	display(length(inlierIndices));
	display('Average residuals for the inliers:');
	display(mean(calc_residuals(H,img1Features(inlierIndices,:),img2Features(inlierIndices,:))));
end
