function [ b ] = isRobust( djk, dkl, dlj, dmin )
% Returns true if the triangle whose edges are djk,dkl,dlj
% has only angles superior to dmin	  

%compute angles
angles=[acos((-djk.^2 + dkl.^2 + dlj.^2) / (2*dkl*dlj));
		acos((+djk.^2 - dkl.^2 + dlj.^2) / (2*djk*dlj));
		acos((+djk.^2 + dkl.^2 - dlj.^2) / (2*djk*dkl))]

%check for angle smaller than dmin
b=(min(angles) > dmin)

end

