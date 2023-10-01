%  [Instructions]
%1. Put .xye files and this script in the same folder
%2. Double-click to open this .m file with Matlab
%3. Adjust the parameters within the %%%%%%%%%% lines (3 sections in total)
%4. Run the script, all windows will close automatically after finished
%5. The .csv files with converted wavelength would be saved in the same folder
%6. The images (.png) files for each spectrum would be saved in the same folder
%7. All spectra in the folder would be plotted in a image named All_spectra
%8. Check the result and adjust the parameters again (especially d & h)
%Code By Tze Yuan Chen
clear ; close all; fclose all; clc; 
%%%%%[section 1]%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ori_wl=0.77491;   %Synchrotron (original) X-ray wavelength λ
tag_wl=1.540598;  %In house X-ray wavelength λ
xyes = ls ('*.xye'); % list all .xye files in the folder 
remove_line=3;  %remove headings
filenamerm=16; %delete "_mar3450_A92.xye"
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fn = size(xyes,1); % number of files
for f = 1: fn
   file_name = strtrim(xyes(f,:));
   fileID = fopen(file_name,'r');
   total_line = 0;
   tline = fgetl(fileID);
   while ischar(tline)   %count total line in file
         tline = fgetl(fileID);
         total_line = total_line+1;
   end
   line_number = total_line - remove_line;
   frewind(fileID);
   for i = 1 : remove_line  %skip headings
        tline = fgets(fileID);
   end
   data=zeros(line_number,3);
   for line = 1 : line_number
       data(line,:) = str2num(fgets(fileID));
       data(line,1) = asind(sin(data(line,1)./2.*pi./180)./ori_wl.*tag_wl).*2;  %convert wave length 
   end
   fclose(fileID);
   new_file_name = (file_name(1:length(strtrim(file_name))-filenamerm)); %delete "_mar3450_A92.xye"
   fileID2 = fopen((new_file_name)+(".csv"),'w'); %save csv file
   fprintf(fileID2,('%s'),num2str(data(:,1))+", "+num2str(data(:,2))+newline);
   fclose(fileID2);
   figure('outerposition',get(0,'screensize'))
   title(new_file_name,'Interpreter','none') %figure title
   %Single plot
   %%%%%[section 2]%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   d=2; %compare to nearby data point (>1 integer)
   h=0.1; %higher than those data points by (>0 floating point)
   %strong peak: small d large h; broad peak: large d small h
   accurate=2; %accuracy, default 0.01
   xlabel("2theta")    %figure x axis
   ylabel("Intensity") %figure y axis
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   hold on
   plot(data(:,1),data(:,2))
   axis([(min(data(:,1))-(max(data(:,1))-min(data(:,1)))/50),(max(data(:,1))+(max(data(:,1))-min(data(:,1)))/50),0,(max(data(:,2))*1.1)]);
   for i = 1:1:length(data)-2*d
      if  data(i+d,2)-data(i,2) > h && data(i+d,2)-data(i+2*d,2) > h && data(i+d,2)-data(i+d+1,2) > 0 && data(i+d,2)-data(i+d-1,2) > 0
          plot(data(i+d,1),data(i+d,2),'-o','color','r')
          ht=text(data(i+d,1),data(i+d,2)+(max(data(:,2))/50),[num2str(round(data(i+d,1)*10^accurate)/10^accurate) ', ' num2str(round(tag_wl/(2*sin(data(i+d,1)/2/180*pi))*10^accurate)/10^accurate)]);
          set(ht,'Rotation',90,'fontsize',8)
      end
   end
   print(gcf,new_file_name,'-dpng')
   hold off
   close
end

%Muti plot
figure('outerposition',get(0,'screensize'))
%%%%%[section 3]%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figtitle="All_spectra"; %title 
d=2; %compare to nearby data point (>1 integer)
h=0.1; %higher than those data points by (>0 floating point)
sp=50; %space between each profile
k=1; %whole peak :1; small peak: 2
show_2theta = "y"; %show 2theta (y/n)
show_dspacing = "y"; %show d-spacing (y/n)
accurate=2; %accuracy, default 0.01
xlabel("2theta")    %figure x axis
ylabel("Intensity") %figure y axis
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
title(figtitle,'Interpreter','none') 
hold on
csvs = ls ('*.csv'); % list all .xye files in the folder 
cfn = size(csvs,1); % number of files
maxy=zeros(cfn,1);
maxx=zeros(cfn,1);
minx=zeros(cfn,1);
for n=1:cfn
    dataall=load(csvs(n,:));
    dataall(:,2)=dataall(:,2)+((n-1)*sp);
    if k ==1
        texth=(max(dataall(:,2))/50);
    elseif k==2
        texth=((cfn/2)*sp/50);
    else
        str={'Wrong k value (whole peak :1; small peak: 2)'};
    end
    maxy(n)=max(dataall(:,2));
    maxx(n)=max(dataall(:,1));
    minx(n)=min(dataall(:,1));
    plot(dataall(:,1),dataall(:,2));
    file_name = strtrim(csvs(n,:));
    file_name = (file_name(1:length(file_name)-4));
    text(dataall(1,1),(n-1)*sp+0.2*sp,file_name,'Interpreter','none')
    for i = 1:1:length(dataall)-2*d
       if  dataall(i+d,2)-dataall(i,2) > h && dataall(i+d,2)-dataall(i+2*d,2) > h && dataall(i+d,2)-dataall(i+d+1,2) > 0 && dataall(i+d,2)-dataall(i+d-1,2) > 0
           plot(dataall(i+d,1),dataall(i+d,2),'-o','color','r')
           if (show_2theta == "y") && (show_dspacing == "y")
               ht=text(dataall(i+d,1),dataall(i+d,2)+texth,[num2str(round(dataall(i+d,1)*10^accurate)/10^accurate) ', ' num2str(round(tag_wl/(2*sin(dataall(i+d,1)/2/180*pi))*10^accurate)/10^accurate)]);
           elseif (show_2theta ~= "y") && (show_dspacing == "y")
               ht=text(dataall(i+d,1),dataall(i+d,2)+texth,num2str(round(tag_wl/(2*sin(dataall(i+d,1)/2/180*pi))*10^accurate)/10^accurate));
           elseif (show_2theta == "y") && (show_dspacing ~= "y")
               ht=text(dataall(i+d,1),dataall(i+d,2)+texth,num2str(round(dataall(i+d,1)*10^accurate)/10^accurate));
           else
               ht=text(dataall(i+d,1),dataall(i+d,2)+texth,"");
           end
           set(ht,'Rotation',90,'fontsize',8)
       end
    end
end
if k ==1
    axish=max(maxy)*1.1;
elseif k==2
    axish=((cfn)*sp);
end
xrange=(max(maxx)-min(minx));
axis([(min(minx)-xrange/50),(max(maxx)+xrange/50),0,axish]);
print(gcf,figtitle,'-dpng')
clear ; close all; fclose all; clc; 
