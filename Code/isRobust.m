function [ b ] = isRobust( djk, dkl, dlj, dmin )
% Returns true if distance_min*(sin(angle_min))^2 > dmin  

%compute angles
angles=[acos((-djk.^2 + dkl.^2 + dlj.^2) / (2*dkl*dlj));
		acos((+djk.^2 - dkl.^2 + dlj.^2) / (2*djk*dlj));
		acos((+djk.^2 + dkl.^2 - dlj.^2) / (2*djk*dkl))];

distances=[djk, dkl, dlj];

b=(min(distances)*(sin(min(angles)).^2) > dmin);

end

