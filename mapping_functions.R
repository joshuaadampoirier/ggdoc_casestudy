library('rgdal')
library('ggmap')
library('ggsn')
library('ggdocumentation')
library('cowplot')
library('RColorBrewer')

# SMALL MAP OF BIYANG SAG
# ##############################################################################

# retrieve map image from Google
mapImage <- get_map(location=c(lon=113.2, lat=32.65), 
                    color='color', source='google', zoom=10)

sag <- readOGR('data/shp', 'Biyang_Depression_Details')
sag.points <- fortify(sag)
flt <- readOGR('data/shp', 'Biyang_Faults')
flt.points <- fortify(flt)

# build and return map
g1 <- ggmap(mapImage) + 
    scalebar(dist=10, dd2km=TRUE, model='WGS84', location='topright', 
             y.min=32.3, y.max=33, x.min=112.78, x.max=113.6) +
    geom_polygon(aes(x=long, y=lat, group=group, fill=group),
                 data=sag.points,
                 color='gray55',
                 alpha=0.3) +
    scale_fill_manual(labels=c('Southern Steep', 'Middle Depression', 'Northern Slope'),
                      values=c('salmon', 'plum', 'olivedrab'), name='Biyang Sag') +
    geom_line(aes(x=long, y=lat, group=group),
              data=flt.points,
              color='black', size=1.25, alpha=.5) +
    theme(
        axis.title = element_blank(),
        axis.text  = element_blank(),
        axis.ticks = element_blank(),
        axis.line = element_blank(),
        legend.position = c(.1,.925),
        legend.background = element_rect(fill='white'),
        legend.title = element_text(size=20),
        legend.text = element_text(size=18),
        legend.key.size = unit(2.5, 'lines')
    )
#g1 <- north2(g1)

# REGIONAL MAP OF CHINA
# ##############################################################################
mapImage <- get_map(location=c(lon=115, lat=35),
                    color='color', source='google', zoom=5)

henan <- readOGR('data/shp', 'Henan_Province')
henan.points <- fortify(henan)
henan.points$China <- 'Henan Province'
nanxiang <- readOGR('data/shp', 'Nanxiang_Basin')
nanxiang.points <- fortify(nanxiang)
nanxiang.points$China <- 'Nanxiang Basin'
data <- rbind(henan.points, nanxiang.points)

g2 <- ggmap(mapImage) + 
    scalebar(dist=500, dd2km=TRUE, model='WGS84', location='topright', 
             y.min=23.75, y.max=45, x.min=102, x.max=127.5) +
    geom_polygon(aes(x=long, y=lat, group=China, fill=China),
                 data=data,
                 color='gray55',
                 alpha=0.3) +
    scale_fill_manual(values=c('gray55', 'firebrick')) +
    theme(
        axis.title = element_blank(),
        axis.text = element_blank(),
        axis.ticks = element_blank(),
        axis.line = element_blank(),
        legend.position = c(.18, .89),
        legend.background = element_rect(fill='white'),
        legend.title = element_text(size=20),
        legend.text = element_text(size=18),
        legend.key.size = unit(2.5, 'lines')
    )

# MEDIUM MAP OF NANXIANG BASIN
# ##############################################################################
mapImage <- get_map(location=c(lon=112, 32.65),
                    color='color', source='google', zoom=8)

nanxiangdet <- readOGR('data/shp', 'Nanxiang_Details')
nanxiangdet.points <- fortify(nanxiangdet)

g3 <- ggmap(mapImage) + 
    scalebar(dist=50, dd2km=TRUE, model='WGS84', location='topright', 
             y.min=31.3, y.max=34, x.min=110.4, x.max=113.6) +
    geom_polygon(aes(x=long, y=lat, group=group, fill=group),
                 data=nanxiangdet.points,
                 color='gray55',
                 alpha=0.3) +
    scale_fill_manual(name='Nanxiang Basin', labels=c('Nanyang Sag',
                                                      'Xiangzao Sag',
                                                      'Biyang Sag',
                                                      'Shigang Uplift',
                                                      'Xinye Uplift',
                                                      'Sheqi Uplift'),
                      values=c('darkseagreen1', 'darkseagreen3', 'firebrick',
                               'darkorange1', 'darkorange3', 'darkorange4')) +
    theme(
        axis.title = element_blank(),
        axis.text = element_blank(),
        axis.ticks = element_blank(),
        axis.line = element_blank(),
        legend.position = c(.17, .75),
        legend.background = element_rect(fill='white'),
        legend.title = element_text(size=20),
        legend.text = element_text(size=18),
        legend.key.size = unit(2.5, 'lines')
    )

g <- plot_grid(g1, plot_grid(g2, g3, ncol=1), ncol=2, rel_widths=c(2,1))

png("figures/biyang_studyarea.png", width=1700, height=1200, units="px", bg="white")
doc_plot(g,
         author='Joshua Poirier',
         author_title='Geoscientist',
         img_sponsor='reference/NEOS-White_small.png',
         data_source='Sources: Dong (2015), GADM, Google, Guo (2014)',
         base_size=32)
dev.off()