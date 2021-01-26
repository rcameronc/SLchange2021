%% Recap Sesion 1 - Matlab Basics (Sea Level Change, Spring 2020)
% Based on Spring 2019 script
%
% Note, this script must be in your current working directory or located in
% a directory that is included in your matlab environment paths.

clc %clears the command window (or on a mac - cmd k)
clear %clears all previously used variables
close all %closes all open figures

%Information about a function can be obtained by typing help <function
%name> or doc <function name> in the editor.
%e.g., help plot
%e.g., doc plot
%
%Also note, the command doc will open a GUI, allowing you to search the
%Matlab documentation.

%% Vectors or N-dimensional Matrices 
%
clc;
clear;
%Vector example
a = 1:5; %creates an array going from 1 to 50

%2-D Matrix example
b = [1:5 ; 11:15]; %creates a 2x5 array of [ 1  2  3  4  5
%                                           11 12 13 14 15]
%Note, Matlab stores 2-D and higher dimensional arrays in column major order. Thus, the
%above array is stored in memory as [1 11 2 12 3 13 4 14 5 15]. This is
%will become important when optimizing code that indexes through a matrix. 

%% Creating XY Plots - Part 1

clc;
clear;

%generating data
x = 1:50; %creates a vector of numbers going from 1 to 50
y = rand(length(x),1); % creates a vector of 50 random numbers

%plotting
h = figure(); %creates a figures and returns the figure handle (h)
plot(x,y,'-r'); %plots the data as a solid red line
xlabel('Vector');
ylabel('Random Values');
title('An Example Plot');

%% Adding more data to plot - Part 2
y2 = rand(length(x), 1);

% add this new data to the plot
hold on; %tells matlab to plot on the same figure as before
plot(x, y2, '-k'); %plot data as a black line this time 
legend('Random set 1', 'Random set 2'); % create a legend

%saving the plot
print(h, '-dpng', 'sample_plot.png');

%% For loops

clc;
clear;
close all;

x = 1:50; %creates a vector of numbers going from 1 to 50
disp("a")
%1-D arrays
for i=2:+2:length(x)
    disp(x(i));
end

%% 2-D arrays 

clc;
clear;

A = rand(10000,10000); %generates a 10,000x10,000 matrix of random numbers 
[r, c] = size(A);

%A 2-D array can be traversed using 2 nested for loops 
%Here values are read accross columns and then down rows
total = 0;
tic %start timer
for i=1:r
    for j=1:c
        total = total + A(i,j);
    end
end
toc %stop timer
disp(total)

%Here values are read down rows and then across columns
total = 0;
tic
for i=1:c
    for j=1:r
        total = total + A(j,i);
    end
end
toc
disp(total)

% Question:
% Which set of for loops are faster and why?


%% Loading existing data and plot it (Part 1 or 2)
clc;
close all;
clear;

%the folder where you keep your data
datapath = './'; %you will need to change this to your folder
load([datapath 'etopo_ice_15.mat']) % be sure to look at the data
% load(['etopo_ice_15.txt']) % be sure to look at the data


% num1 = size(unique(etopo_15(:,1)));
% num2 = size(unique(etopo_15(:,2)));

%plotting a map of matrices
hh = figure;
% LON = squeeze(reshape(etopo_15(:,1), [num1, num2]));
% LAT = squeeze(reshape(etopo_15(:,2), [num1, num2]));
% % [LON, LAT] = meshgrid(etopo_15(:,1), etopo_15(:,2)); 
% topo_bed = squeeze(reshape(etopo_15(:,3), [num1, num2]));
pcolor(LON, LAT, topo_ice) %plots a color map of the data
% pcolor(etopo_15(:,1), etopo_15(:,2), etopo_15(:,3)) %plots a color map of the data

shading flat %changes the lighting making map visible
axis([230 310 10 60]) %sets the axis limits so we can just view the US
xlabel('\circ Longitude')
ylabel('\circ Latitude')
demcmap([-1000 1000]) % this will not work without the mapping toolbox
cb = colorbar;
ylabel(cb, 'Elevation (m)')


%% Selecting a subset of data (Part 2 or 2)

%i am interested in the Florida peninsula -- let's draw a box around it
fl_lon = [276, 277, 280.5, 280.5, 280,276]; % some longitudes of FL 
fl_lat = [30, 24.5, 25, 27.6, 30.5, 30]; %some latitudes

hold on
plot(fl_lon, fl_lat, '-r') %drawing the box on the map we have created

%inpolygon is a function that checks to see if data is inside a defined
%box
in = inpolygon(LON,LAT,fl_lon,fl_lat); % remember you can type help inpolygon in the editor to get more info
in = double(in); %converts data from logical (true/false) to numbers, allowing for multiplication
in(in==0) = nan; %replace zeros in dataset with NaNs

%using matrix multiplication to eliminate data outside of our area of
%interest
topo_FL = in.*topo_ice;

%plot this
hf = figure;
pcolor(LON, LAT, topo_FL) %plots a color map of the data
shading flat %changes the lighting making map visible
axis([270 290 20 40]) %sets the axis limits 
xlabel('\circ Longitude')
ylabel('\circ Latitude')
demcmap([-1000 1000])
cb = colorbar;
ylabel(cb, 'Elevation (m)')


% let's find out some info about what the elevation of FL peninusula is
dataexists = find(~isnan(topo_FL)); % first find out what data exists (is not a NaN)
abovezero = find(topo_FL >= 0); %now let's look at what data is above zero
above20 = find(topo_FL > 20); % now above 20
above50 = find(topo_FL > 50); % and fifty

%calculate the percent above that level
perc_above_0 = length(abovezero)/length(dataexists)*100;
perc_above_20 = length(above20)/length(dataexists)*100;
perc_above_50 = length(above50)/length(dataexists)*100;


