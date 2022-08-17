function out=SubsetEntropy(F,bits) % needs 1 larger than subset in each direction and raw image (this is just basically subset entropy just without division to normalise it)
	ycheck=2:1:size(F,1)-1;
	xcheck=2:1:size(F,2)-1;
	Ftemp=F(ycheck,xcheck);

	F1=abs(Ftemp-F(ycheck-1,xcheck-1));
	F2=abs(Ftemp-F(ycheck,xcheck-1));
	F3=abs(Ftemp-F(ycheck+1,xcheck-1));
	F4=abs(Ftemp-F(ycheck-1,xcheck));
	F5=abs(Ftemp-F(ycheck+1,xcheck));
	F6=abs(Ftemp-F(ycheck-1,xcheck+1));
	F7=abs(Ftemp-F(ycheck,xcheck+1));
	F8=abs(Ftemp-F(ycheck+1,xcheck+1));
	out=sum(F1+F2+F3+F4+F5+F6+F7+F8,'all');

	out=out/(2^bits*(size(F,1)-2)*(size(F,1)-2));

end