function [featureDescriptions] = describe_features(img,radius,r,c)
NumberFeatures=length(r);
featureDescriptions=zeros(NumberFeatures,(2* radius +1)^2);

PadHelp=zeros(2*radius +1);
PadHelp(radius + 1,radius +1)=1;

Paddedimg=imfilter(img,PadHelp,'replicate','full');

for i=1:NumberFeatures
	RangeR=r(i):r(i) + 2* radius;
	RangeC=c(i):c(i) + 2* radius;
	neighborhood=Paddedimg(RangeR,RangeC);
	flatFeaturesVector=neighborhood(:);
	featureDescriptions(i,:)=flatFeaturesVector;
end
featureDescriptions=zscore(featureDescriptions')';
end
