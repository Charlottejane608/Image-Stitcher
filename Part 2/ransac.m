function [bestFitModel, inlierindices] = ransac(parameters,matches,FittingModel,errorFxn)


	[numMatches,~]=size(matches);
	numberofInliers=zeros(parameters.numIterations,1);
	storedModels={};

	for i=1: parameters.numIterations 	
		subsetIndices=randsample(numMatches,parameters.subsetSize);
		matches_subset=matches(subsetIndices,:);

		model=FittingModel(matches_subset,parameters.bShouldNormalizePts);

		residualerrors=errorFxn(model,matches);
		inlierindices=find(residualerrors < parameters.inlierDistThreshold);
		numberofInliers(i)=length(inlierindices);

		currentInlierratio=numberofInliers(i)/numMatches;
		if currentInlierratio >= parameters.minInlierRatio;
			matches_inliers=matches(inlierindices,:);
			storedModels{i}=FittingModel(matches_inliers,parameters.bShouldNormalizePts);
		end
	end
	bestIterations=find(numberofInliers==max(numberofInliers));
	bestIterations=bestIterations(1);
	bestFitModel=storedModels{bestIterations};

	residualerrors=errorFxn(bestFitModel,matches);

	inlierindices=find(residualerrors < parameters.inlierDistThreshold);
end
