library('ggplot2')
library('ggdocumentation')

# load data
data <- read.csv('data/fracture_data.csv')
head(data)

logs <- c('DT', 'RHO', 'PHIN', 'R_XO', 'R_LLD', 'R_LLS', 'R_DS')

# loop through logs calculating correlation
df <- data.frame(LOG=character(), WELL=character(), COR=numeric())
for (log in logs) {
    An1 <- data$Well == 'An1'
    An2 <- data$Well == 'An2'
    
    df <- rbind(df, data.frame(
        LOG=rep(log,3),
        WELL=c('Both', 'An1', 'An2'),
        COR=c(cor(data[,log], data$IL), cor(data[An1,log], data[An1,'IL']), cor(data[An2,log], data[An2,'IL']))
        ))

}

g <- ggplot(df, aes(LOG, WELL, fill=COR)) +
    geom_tile(colour="white") +
    theme_grey(base_size=9) +
    labs(x="", y="", title="Correlating logs with fracture presence across wells") +
    scale_y_discrete(expand=c(0,0)) + scale_x_discrete(expand=c(0,0)) +
    scale_fill_gradient2(name="Correlation", low="steelblue", mid="white", high="firebrick") +
    theme(
        title = element_text(size=20),
        legend.position = "right",
        legend.key.height = unit(130, 'pt'),
        legend.title = element_text(size=20),
        legend.text = element_text(size=20),
        axis.ticks = element_blank(),
        axis.text = element_text(size=20)
    )

png('figures/log-correlation.png', width=1800, height=800, units='px')    
doc_plot(g,
         author='Joshua Poirier',
         author_title='Geoscientist',
         img_sponsor='reference/NEOS-White_small.png',
         data_source='Source: Shi (2014)',
         base_size=24)
dev.off()