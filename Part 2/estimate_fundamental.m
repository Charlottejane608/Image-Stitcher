function[F] =estimate_fundamental(matches,bShouldNormalizePts)


	parameters.numIterations=1000;
	parameters.subsetSize=8;
	parameters.inlierDistThreshold=35;
	parameters.minInlierRatio=20/size(matches,1);
	parameters.bShouldNormalizePts=bShouldNormalizePts;

	[F,inlierindices]=ransac(parameters,matches,@fit_fundamental,@calc_residuals);
	display(['\n Number of inliers is: ', num2str(length(inlierindices))]);
	display('The Mean Residual of the inlieres is:');
	display(mean(calc_residuals(F,matches(inlierindices,:))));

end 	
