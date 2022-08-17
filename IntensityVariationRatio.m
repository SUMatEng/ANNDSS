function out=IntensityVariationRatio(I)
	% sumfx=0; sumfy=0;
	out=(sum(abs(I(:,2:end)-(I(:,1:end-1))),'all')+sum(abs(I(2:end,:)-I(1:end-1,:)),'all'))/(2*size(I,2)+2*size(I,1));

end