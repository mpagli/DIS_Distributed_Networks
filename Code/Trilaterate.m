%% find the coordinates of P belongig to the robust quad. P,Pa,Pb,Pc
function [Position] = Trilaterate (Pa,daj,Pb,dbj,Pc,dcj)

% get intersection between the circles (Pa,daj) and (Pb,dbj)
[xout1,yout1] = circcirc(Pa(1),Pa(2),daj,Pb(1),Pb(2),dbj);  
% get intersection between the circles (Pc,dcj) and (Pb,dbj)
[xout2,yout2] = circcirc(Pc(1),Pc(2),dcj,Pb(1),Pb(2),dbj);
% get intersection between the circles (Pc,dcj) and (Pa,daj)
[xout3,yout3] = circcirc(Pc(1),Pc(2),dcj,Pa(1),Pa(2),daj);

%return the best solution among the set [xout1,yout1],[xout2,yout2],[xout3,yout3]   
Solutions=[ xout1(1),xout1(2),xout2(1),xout2(2),xout3(1),xout3(2);
            yout1(1),yout1(2),yout2(1),yout2(2),yout3(1),yout3(2)];

mask = combnk(1:6,2);
Norm_vec=zeros(1,length(mask));

for i=1:length(mask)
   Norm_vec(i)=norm(Solutions(:,mask(i,1))-Solutions(:,mask(i,2)));
end

[Norm_vec,index]=sort(Norm_vec);

mask=mask(index,:);

final_set=[mask(1,1),mask(1,2),mask(2,1),mask(2,2),mask(3,1),mask(3,2)];

final_set=unique(final_set);

%if( length(final_set) ~= 3)
%    error(sprintf('Oups'));
%end

Position=1/3*(Solutions(:,final_set(1))+Solutions(:,final_set(2))+Solutions(:,final_set(3))); %return the average

end
