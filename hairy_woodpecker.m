%Delaney Vorwick
%Environmental Data Exploration and Analysis Final Project

%To request this data from eBird, visit the site below. 
%https://ebird.org/data/download

%Once request is approved, select species option "Hairy Woodpecker"
%and region as "Massachusetts"

%Load .txt file into MATLAB using the "Import Data" tool, rename "HAIRY"
%replace Nan values with 1

%Deleted values before the year 2000 (not a lot of data) and 2020 (not
%complete yet)
dateH=HAIRY{:,6};
year=dateH.Year;
dateH(dateH.Year<2000)=[];
dateH(dateH.Year==2020)=[];

%create a variable named Hobs for observations of Hairy Woodpeckers
Hobs=HAIRY{:,2};
Hobs=Hobs(1:length(dateH),:);

%yearly averages
yearH=datevec(dateH);
yearH=yearH(:,1);
matrixH=[yearH Hobs];
[years, ~, subs] = unique(matrixH(:, 1));
yearsumH = accumarray(subs, matrixH(:, 2));

edges = unique(yearH);
counts = histc(yearH(:), edges);
yearaverageH=yearsumH./counts;

%% 

%plot observed vs year
figure(1)
plot(years,yearaverageH) 
title('Average Count of Hairy Woodpeckers per Observation period')
xlabel('year')
ylabel('Count')
%% 

%variables for lat and lon
lat=HAIRY{:,4};
lon=HAIRY{:,5};

%reshape
lat=lat(1:length(dateH),:);
lon=lon(1:length(dateH),:);

%% mass state map

states = geoshape(shaperead('usastatehi', 'UseGeoCoords', true));
stateName = 'Massachusetts';
ma = states(strcmp(states.Name, stateName));

figure(2)
oceanColor = [.5 .7 .9];
ax = usamap('ma');
setm(ax, 'FFaceColor', oceanColor)
geoshow(states)
geoshow(ma, 'LineWidth', 1.5, 'FaceColor', [.5 .8 .6])

%% zoom in lol

latlim = [min(lat) max(lat)];
lonlim = [min(lon) max(lon)];
[latlim, lonlim] = bufgeoquad(latlim, lonlim, .05, .05);

figure(3)
ax = usamap(latlim, lonlim);
setm(ax, 'FFaceColor', oceanColor)
geoshow(states)
plotm(lat,lon,'b.')
title('Location of Hairy Woodpecker spottings in MA (2000-2019)')

%% isolate according to year
%create empty matrix to hold lat and lon data for each year
latlonyear=[yearH lat lon];
latyear=[];
lonyear=[];

%ability to change year to reshape matrix according to that year
for i=1:length(yearH)
    if yearH(i)==2019
        latyear=[latyear;lat(i)];
        lonyear=[lonyear;lon(i)];
    end
end

%produce a figure according to which year is put into the if statement
%within the for lo
figure(4)
ax = usamap(latlim, lonlim);
setm(ax, 'FFaceColor', oceanColor)
geoshow(states,'FaceColor', [1 1 1 ])
plotm(latyear,lonyear,'b.')
title('Location of Hairy Woodpecker spottings in MA (2019)')















