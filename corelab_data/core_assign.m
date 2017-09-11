% core_assign.m
% This script attributes formations to core plugs according to 
% the plug depths and tops picked by QEP


% 	A key limitation of this script to note:												%
%	if a plug depth is deeper the deepest top picked, the deepest formation picked will 	%
%	be assigned to the plug.																%
%	e.g.  if the deepest formation with a top for a given well is the LNRD, any plug 		%
%	from a depth greater than the deepest top will be labeled as LNRD.						%
%	i.e. if the plug is from a depth of 13,000ft and the deepest top for that well is 		%
%	the LNRD at 9,000ft, the plug will be labeled as LNRD, despite the fact that it is 	 	%
%	very unlikely that the LNRD is 4,000ft thick											%														%
%	The "Deepest Top" column indicates if a plug is bucketed in this deepest top for QC		%
%	purposes.

clear all; clc; 

% Import data from Excel
% Data in core_tops_copy.xls contains 887 tops has been custom sorted by API and top depth
% Data in plug_depths_copy.xls contains APIs and adjusted depths for 5,051 core plugs


plugdepthsmat = xlsread('plug_depths_copy.xls');
plugdepthapi = plugdepthsmat(:,1); plugdepth=plugdepthsmat(:,2); 
[coreTops,topFormation,topDepth] = xlsread('core_tops_copy.xls');
topDepth = coreTops(:,3);
topAPI = coreTops(:,1);
topFormation = topFormation(:,2);



% Create and initialize cell array to store output

output = cell(1,6);
output{1,1}=zeros(length(plugdepthapi),1);   % contains plug API
output{1,2}=zeros(length(plugdepthapi),1);   % contains plug depths 
output{1,3}=strings(length(plugdepthapi),1); % contains depth of associated formation top 
output{1,4}=strings(length(plugdepthapi),1); % contains QEP picked formation name
output{1,5}=strings(length(plugdepthapi),1); % contains distance between plug depth and top of formation
output{1,6}=strings(length(plugdepthapi),1); % indicates if a formation is deepest of a given well

for i = 1:length(plugdepthapi)

	% Identify the plugs belonging to wells with no tops picked
	if sum(plugdepthapi(i) == topAPI) == 0

		%output{1,1}(i,1) = sum(plugdepthapi(i) == topAPI);  % count of Plug APIs for QC
		
		output{1,1}(i,1) = plugdepthapi(i);
		output{1,2}(i,1) = plugdepth(i);
		output{1,3}(i,1) = 'no QEP tops associated with this API';
		output{1,4}(i,1) = 'no QEP tops associated with this API';
		output{1,5}(i,1) = 'no QEP tops associated with this API';
		output{1,6}(i,1) = 'no QEP tops associated with this API';

	% Identify the plugs whose depth falls above the range of identified tops for a
	% given well

	elseif sum(topDepth(plugdepthapi(i) == topAPI & topDepth <= plugdepth(i))) ==0 
		
		output{1,1}(i,1) = plugdepthapi(i);
		output{1,2}(i,1) = plugdepth(i);
		output{1,3}(i,1) = 'plug shallower than highest QEP top';
		output{1,4}(i,1) = 'plug shallower than highest QEP top';
		output{1,5}(i,1) = 'plug shallower than highest QEP top';
		output{1,6}(i,1) = 'plug shallower than highest QEP top';

	% Find formation associated with each plug by API and adjusted top depth

	else

	output{1,1}(i,1) = plugdepthapi(i);
	output{1,2}(i,1) = plugdepth(i);
	output{1,3}(i,1) = max(topDepth(plugdepthapi(i) == topAPI & topDepth <= plugdepth(i))); 
	output{1,4}(i,1) = topFormation((max(find(plugdepthapi(i) == topAPI & topDepth ...
							<= plugdepth(i)))));	
	output{1,5}(i,1) = plugdepth(i) - max(topDepth(plugdepthapi(i) == topAPI & ...
						topDepth <= plugdepth(i))); 
		
	% If the formation assigned to a core plug is the last in a set of tops, label "yes"

		if max(find(plugdepthapi(i) == topAPI & topDepth <= plugdepth(i))) ...
				== max(find(plugdepthapi(i) == topAPI))
			output{1,6}(i,1) = 'yes';
		else
			output{1,6}(i,1) = 'no';
		end
	end
end
	

out = [output{1,1}(:,1) output{1,2}(:,1) output{1,3}(:,1) output{1,4}(:,1) output{1,5}(:,1) ...
	output{1,6}(:,1)];
header = cell(1,6);
header{1,1}='Plug API';
header{1,2}='Adjusted Plug Depth';
header{1,3}='Depth of QEP Top';
header{1,4}='Formation From QEP Tops';
header{1,5}='Plug Distance from QEP Top';
header{1,6}='Deepest Top';

out = [header; out];

% Export data to excel
 content = fopen('assignedformations.csv','wt');
 if content>0
     for k=1:size(out,1)
         fprintf(content,'%s,%s,%s,%s,%s,%s\n',out{k,:});
     end
     fclose(content);
 end



