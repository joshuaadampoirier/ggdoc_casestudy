library('tools')
library('ggdocumentation')
library('cowplot')

read.tensorboard.log <- function(fname) {
    
    # argument validation
    if (! file.exists(fname)) stop(paste('File', fname, 'cannot be found or does not exist'))
    if (file_ext(fname) != 'csv') stop('TensorBoard logs must be given as comma-separated value (CSV) file format')
    
    # read data
    x <- read.csv(fname)
    
    # data validation
    if (ncol(x) != 3) stop('TensorBoard logs must have only 3 columns (Wall time, Step, and Value')
    
    # return data frame
    x
    
}

plot_train_vs_valid <- function(x, color='black', ytitle='', title='') {
    
    if (!is.data.frame(x) | ncol(x) != 3) stop('Given parameter "x" must be a data frame with 3 columns')
    
    g <- ggplot() + theme_grey() +
        labs(x='Training Step Number', y=ytitle, title=title) +
        ylim(0,1) +
        geom_line(data=x, aes(x=Step, y=Value), col=color, alpha=.5, size=2) + 
        scale_color_manual(name='', values=c('dodgerblue', 'forestgreen')) +
        theme(
            title = element_text(size=20),
            axis.title = element_text(size=24),
            axis.text = element_text(size=24),
            legend.position = 'bottom',
            legend.text = element_text(size=20)
        )
    
    g
    
}

# load data
valid_acc <- read.tensorboard.log('tensorboard_logs/run_c-PD6OTI,tag_Accuracy-Validation.csv')
train_los <- read.tensorboard.log('tensorboard_logs/run_c-PD6OTI,tag_Loss.csv')

# build plots
g1 <- plot_train_vs_valid(valid_acc, color='dodgerblue',
                          ytitle='Accuracy', title='Neural Network Validation Accuracy')
g2 <- plot_train_vs_valid(train_los, color='forestgreen', 
                          ytitle='Loss', title='Neural Network Training Loss')

g <- plot_grid(g1, g2, ncol=2)

png('figures/nn-performance.png', width=1800, height=800, units='px')    
doc_plot(g,
         author='Joshua Poirier',
         author_title='Geoscientist',
         img_sponsor='reference/NEOS-White_small.png',
         base_size=24)
dev.off()