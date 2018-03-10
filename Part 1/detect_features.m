function [r1, c1, r2, c2]=detect_features(img1,img2);
	sigma=2 ;
	thresh=0.05;
	radius=2;
	disp=5;
	[~, r1, c1]=harris(img1,sigma, thresh, radius,disp);
 	[~, r2, c2]=harris(img2,sigma, thresh, radius,disp);
end
