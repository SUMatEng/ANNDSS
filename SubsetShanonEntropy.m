function out=SubsetShanonEntropy(F,bits)
	% out=0;
	% Flin=F(:);
	bitCheck=0:1:2^bits-1;
	count=sum(F(:)==bitCheck,1);
	temp=size(F,1)*size(F,2);
	count2=count(count>0);
	out=-sum(count2./temp.*(log2(count2./temp)),'all');
end