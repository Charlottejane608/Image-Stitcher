function [composite]=stitch(img1,img2,H)
	[h1, w1,numberChannel1]=size(img1);
	[h2, w2,numberChannel2]=size(img2);

	corners=[1 1 1;
			w1 1 1;
			w1 h1 1;
			1 h1 1];
	warpingtheCorners=homo_2_cart(corners * H);

	minX=min(min(warpingtheCorners(:,1)),1);
	maxX=max(max(warpingtheCorners(:,1)),w2);
	minY=min(min(warpingtheCorners(:,2)),1);
	maxY=max(max(warpingtheCorners(:,2)),h2);

	xResolutionRange=minX:maxX;
	yResolutionRange=minY:maxY;
	
	[x y]=meshgrid(xResolutionRange,yResolutionRange);
	Hinv=inv(H);


	warpedHomoScaleFactor= Hinv(1,3)*x + Hinv(2,3)*y + Hinv(3,3);
	warpX	=(Hinv(1,1) * x + Hinv(2,1) * y + Hinv(3,1)) ./ warpedHomoScaleFactor;
	warpY	=(Hinv(1,2) * x + Hinv(2,2) * y + Hinv(3,2)) ./ warpedHomoScaleFactor;


	if numberChannel1==1
		%%images are black and white. Simple interpolation will suffice
		newLeftHalf=interp2(im2double(img1),warpX,warpY,'cubic');
		newRightHalf=interp2(im2double(img2),x,y,'cubic');
	else
		newLeftHalf=zeros(length(yResolutionRange),length(xResolutionRange),3);
		newRightHalf=zeros(length(yResolutionRange),length(xResolutionRange),3);
		for i=1:3	
			newLeftHalf(:,:,i)=interp2(im2double(img1(:,:,1)),warpX,warpY,'cubic');
			newRightHalf(:,:,i)=interp2(im2double(img2(:,:,i)),x,y,'cubic');
		end
	end
newWeight= ~isnan(newLeftHalf) + ~isnan(newRightHalf);
newLeftHalf(isnan(newLeftHalf)) = 0;
newRightHalf(isnan(newRightHalf)) = 0;
composite=(newLeftHalf+newRightHalf) ./ newWeight;

end