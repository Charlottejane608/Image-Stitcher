function residuals= calc_residuals(F,matches)
	numMatches=size(matches,1);
	
	L= ( F *  [matches(:,1:2) ones(numMatches,1)]')';

	L= L ./ repmat(sqrt(L(:,1).^2 + L(:,2).^2),1,3);
	
	distances=sum(L .* [matches(:,3:4) ones(numMatches,1)],2);
	
	residuals=abs(distances);
end
