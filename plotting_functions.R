library('tools')
library('ggdocumentation')
library('ggthemes')

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

plot_train_vs_valid <- function(train, valid, fname, ytitle='', title='') {
    
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
            axis.title = element_text(size=20),
            axis.text = element_text(size=20),
            legend.position = 'bottom'
        )
    
    png(fname, width=1200, height=800, units='px')    
    doc_plot(g,
          author='Joshua Poirier',
          author_title='Geoscientist',
          #data_source='Source: Shi, 2014',
          img_sponsor='reference/NEOS-White_small.png',
          base_size=24)
    dev.off()
    
}

# load data
train_acc <- read.tensorboard.log('tensorboard_logs/run_WMZTT0,tag_Accuracy.csv')
valid_acc <- read.tensorboard.log('tensorboard_logs/run_WMZTT0,tag_Accuracy-Validation.csv')
train_los <- read.tensorboard.log('tensorboard_logs/run_WMZTT0,tag_Loss.csv')
valid_los <- read.tensorboard.log('tensorboard_logs/run_WMZTT0,tag_Loss-Validation.csv')

# build plots
plot_train_vs_valid(train_acc, valid_acc, fname='figures/run_WMZTT0_accuracy.png', 
                    ytitle='Accuracy', title='Fracture prediction accuracy during neural network training')
plot_train_vs_valid(train_los, valid_los, fname='figures/run_WMZTT0_loss.png', 
                    ytitle='Loss (Categorical Cross-Entropy)', title='Fracture prediction loss during neural network training')