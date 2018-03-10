function[FeatureDescriptions]= describe_features(img,radius,r,c)
numberfeat=length(r); %number of features



FeatureDescriptions=zeros(numberfeat,(2*radius+1)^2);
padHelper=zeros(2*radius+1);
padHelper(radius+1,radius+1)=1;
paddedimg=imfilter(img,padHelper,'replicate','full');

for i=1:numberfeat
	rangeR=r(i) : r(i) + 2 * radius;
	rangeC=c(i) : c(i) + 2 * radius;
	neighborhood=paddedimg(rangeR,rangeC);
	flattenedFeatureVectors=neighborhood(:);
	FeatureDescriptions(i,:)=flattenedFeatureVectors;
end

FeatureDescriptions=zscore(FeatureDescriptions')';

end

