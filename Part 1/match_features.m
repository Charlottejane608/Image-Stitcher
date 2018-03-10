function [img1Feature,img2Feature]=match_features(numberMatches,Descriptions1,Descriptions2)
	distances=dist2(Descriptions1,Descriptions2);
	[~,distancecheck]=sort(distances(:),'ascend');
	bestoftheMatches=distancecheck(1:numberMatches);

	[row_DMat,col_DMat]=ind2sub(size(distances),bestoftheMatches);
	img1Feature=row_DMat;
	img2Feature=col_DMat;
end
