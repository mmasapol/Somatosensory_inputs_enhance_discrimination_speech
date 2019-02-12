## Load packages
library(tidyverse)
library(psych)
library(readxl)
library(plyr)
library(psych)


## Experiment 1 - Dynamic speech

## Load data frame
Experiment1_dynamic_speech <- read_xlsx(file.choose())

## View data frame
View(Experiment1_dynamic_speech)

Experiment1_dynamic_speech$Vowel_contrast <- revalue(x = Experiment1_dynamic_speech$Vowel_contrast, c("En_u_Fr_u" = "English /u/ - French /u/", "E_AE" = "English /ɛ-æ/"))

Experiment1_dynamic_speech %>%
  ggplot() + geom_boxplot(aes(Condition,A_prime_Score),notch=FALSE, outlier.shape = NA) +
  facet_grid(.~Vowel_contrast) +
  theme(strip.text = element_text(face="bold", size = 20)) +
  theme(axis.title = element_text(size = 18),
        axis.text = element_text(size = 16),
        legend.title = element_text(size = 18),
        legend.text = element_text(size = 18)) +
  ylim(0.5,1.0) +
  ylab("Perceptual Sensitivity (A')") +
  xlab("Experimental Condition") + 
  scale_x_discrete(labels=c("baseline" = "Baseline", "bite_block" = "Block\nBite", "lip_tube" = "Lip\nTube")) +
  theme(axis.text=element_text(size=20),
        axis.title=element_text(size=24,face="bold")) +
  theme(legend.text=element_text(size=20),
        legend.title = element_text(size=24))



## Experiment 2 - Stilled facial speech images

## Load data frame
Experiment2_static_speech <- read_xlsx(file.choose())

## View data frame
View(Experiment2_static_speech)

Experiment2_static_speech$Vowel_contrast <- revalue(x = Experiment2_static_speech$Vowel_contrast, c("En_u_Fr_u" = "English /u/ - French /u/", "E_AE" = "English /ɛ-æ/"))

Experiment2_static_speech %>%
  ggplot() + geom_boxplot(aes(Condition,A_prime_Score),notch=FALSE, outlier.shape = NA) +
  facet_grid(.~Vowel_contrast) +
  theme(strip.text = element_text(face="bold", size = 20)) +
  theme(axis.title = element_text(size = 18),
        axis.text = element_text(size = 16),
        legend.title = element_text(size = 18),
        legend.text = element_text(size = 18)) +
  ylim(0.5,1.0) +
  ylab("Perceptual Sensitivity (A')") +
  xlab("Experimental Condition") + 
  scale_x_discrete(labels=c("baseline" = "Baseline", "bite_block" = "Block\nBite", "lip_tube" = "Lip\nTube")) +
  theme(axis.text=element_text(size=20),
        axis.title=element_text(size=24,face="bold")) +
  theme(legend.text=element_text(size=20),
        legend.title = element_text(size=24))


## Experiment 3
## Load data frame
Experiment3_staircase <- read_xlsx(file.choose())

## View data frame
View(Experiment3_staircase)

Experiment3_staircase$run <- NULL

Experiment3_staircase$auditory_series <- revalue(x = Experiment3_staircase$auditory_series, c("En_u_Fr_u" = "English /u/ - French /u/", "E_AE" = "English /ɛ-æ/"))

Experiment3_staircase %>%
  ggplot() + geom_boxplot(aes(condition,jnd),notch=FALSE, outlier.shape = NA) +
  facet_grid(.~auditory_series) +
  theme(strip.text = element_text(face="bold", size = 20)) +
  theme(axis.title = element_text(size = 18),
        axis.text = element_text(size = 16),
        legend.title = element_text(size = 18),
        legend.text = element_text(size = 18)) +
  ylim(0,70) +
  ylab("JND (step size)") +
  xlab("Experimental Condition") + 
  scale_x_discrete(labels=c("C" = "Baseline", "BB" = "Block\nBite", "LT" = "Lip\nTube")) +
  theme(axis.text=element_text(size=20),
        axis.title=element_text(size=24,face="bold")) +
  theme(legend.text=element_text(size=20),
        legend.title = element_text(size=24))

