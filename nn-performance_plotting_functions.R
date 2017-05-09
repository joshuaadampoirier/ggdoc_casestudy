library('tools')
library('ggdocumentation')
library('ggthemes')
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

plot_train_vs_valid <- function(train, valid, ytitle='', title='') {
    
    if (!is.data.frame(train) | ncol(train) != 3) stop('Given parameter "train" must be a data frame with 3 columns')
    if (!is.data.frame(valid) | ncol(valid) != 3) stop('Given parameter "valid" must be a data frame with 3 columns')
    
    train$type <- 'Training'
    valid$type <- 'Validation'
    
    data <- rbind(train, valid)
    
    g <- ggplot() + theme_economist_white() +
        labs(x='Training Step Number', y=ytitle, title=title) +
        ylim(0,1) +
        geom_line(data=data, aes(x=Step, y=Value, col=type), alpha=.5, size=2) + 
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
train_acc <- read.tensorboard.log('tensorboard_logs/run_c-PD6OTI,tag_Accuracy.csv')
valid_acc <- read.tensorboard.log('tensorboard_logs/run_c-PD6OTI,tag_Accuracy-Validation.csv')
train_los <- read.tensorboard.log('tensorboard_logs/run_c-PD6OTI,tag_Loss.csv')
valid_los <- read.tensorboard.log('tensorboard_logs/run_c-PD6OTI,tag_Loss-Validation.csv')

# build plots
g1 <- plot_train_vs_valid(train_acc, valid_acc, 
                          ytitle='Accuracy', title='Neural Network Accuracy')
g2 <- plot_train_vs_valid(train_los, valid_los, 
                          ytitle='Loss', title='Neural Network Loss')

g <- plot_grid(g1, g2, ncol=2)

png('figures/nn-performance.png', width=1800, height=800, units='px')    
doc_plot(g,
         author='Joshua Poirier',
         author_title='Geoscientist',
         img_sponsor='reference/NEOS-White_small.png',
         base_size=24)
dev.off()