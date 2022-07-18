
---
title: "Learn Basics of Data Analysis using R "
output:
  html_document:
    toc: yes
    toc_float: yes
  pdf_document:
    toc: yes
date: "`r format(Sys.time(), '%d %B %Y')`"
subtitle: School of Economics, Quaid-i-Azam University

---

![](gapminder.jpg)

```{r setup, include=FALSE}

knitr::opts_chunk$set(echo = FALSE)
```

# Why R

There is an increasing recognition of reproducibility of research, though it has limited recognition in social sciences.  The document in your hand is written in `RMarkdown`. 
`RMarkown` which can be used for pdf, html, word, PowerPoint/Slidy/Beamer Presentations, Webpages, LaTex and many others. 
Besides learning basics of R-coding, another objective of this workshop is understanding the importance of reproducibility. Building this new habit of reproducible work at times maybe little challenging occasionally. Getting rid of culture of copying and pasting, and sparing this time for doing data analysis and research is one of the objectives of this or coming workshops. Purpose is to help you to get away from this tedious activity so that you can spend more time __doing science__.

## Installing and loading packages
The first thing we need to do is install and then load the `tidyverse` set of R packages to provide us with lots of extra functionality. You only need to install this once: once it’s installed we can simply load it into the workspace using the library() function each time we open a new R session.

Understanding data sets requires many hours/days or in some cases weeks.There are many commercially available software but open source community based software have now dominated and R is one of these. R makes data understanding process as easy as possible through the `dplyr` package. It is one of the easiest solution for code-based data analysis. We will learn in this training how to do it. In case, you need more information, you can watch my [videos](https://youtu.be/ZNBZevfYgo0).

I have discussed the [Gapminder dataset](https://cran.r-project.org/web/packages/gapminder/index.html) in my videos and we shall use it throughout this training. It's available through CRAN, so make sure to install it. Here's how to load in all required packages:

```{r , warning=FALSE,message=FALSE}
library(tidyverse)
library(knitr)
library(kableExtra)
#install.packages("gapminder")
library(hrbrthemes)
library(viridis)
library(kableExtra)
options(knitr.table.format = "html")
library(plotly)
library(gridExtra)
library(ggrepel)

# The dataset is provided in the gapminder library
library(gapminder)

gapminder %>% filter(country=="Sweden")%>%
  mutate(gdpPercap=round(gdpPercap,0), lifeExp=round(lifeExp,2))%>%kable()%>%
  kable_styling(bootstrap_options = "striped", full_width = F)

```

First few rows of data are displayed here and there 1704 observations in total. In this training, some very basic but important things you will learn are

# Key components of handling data

-   View, glimpse, structure
-   head, tail
-   Column Selection
-   Data Filtering
-   Data Ordering
-   Creating Derived Columns
-   Calculating Summary Statistics
-   Grouping

## Information in **gapminder** data

`View` command opens data in new worksheet while glimpse lists nature of variables (numeric/character/factor...) and total number of rows and columns.

```{r data-structure, comment= ""}
glimpse(gapminder) # We see that there are 1704 rows for 6 columns and also tells nature of variable
#View(gapminder)    # This opens up full data in a new window
```

```{r }
summary(gapminder) 

```


# dplyr features

1. `filter()` to keep selected observations
2. `select()` to keep selected variables
3. `arrange()` to reorder observations by a value
4. `mutate()` to create new variables
5. `summarize()` to create summary statistics
6. `group_by()` for performing operations by group


Now I shall mention some of the powerful but very simple to use features of dplyr.
## Column Selection

More often than not, you don't need all columns of a data set for your analysis. For example `PDHS` files have more than 5000 columns in some files and maybe 40 or 50 or even fewer than that are needed for your analysis. `Select()` function of R's dplyr is used to select columns of your interest
Three selected columns are selected as follows. You can give new name to this data.

```{r}
gapminder %>% select(country, pop, lifeExp)%>%kable()%>%
  kable_styling(bootstrap_options = "striped", full_width = F)

```

In case you want to select most of the variables and drop one or two, you may proceed as follows

```{r}
gapminder %>% select(-gdpPercap)

```

So `gdpPerCapita` column is now not shown above.

## Data Filtering

Filtering is another very important task one has to do in one's analysis. Sometimes, one has to select sale related to a particular city or agent or quarter. Here is how one uses `filter()` command for data with a condition. We are using here command only to select data for year 2007 for all the countries.
I am going to explain `filter` variable of dplyr. `filter` is used only to select rows for a given condition. I am going to select data only for year 2007.

```{r}
gapminder_07<- gapminder %>% filter(year==2007)
kbl(gapminder_07[1:10,])%>%kable_styling(fixed_thead=T)
```

Compared to previous one, `gapminder` is showing data only for 142 rows. Pipes %>% play very nicely with dplyr and make our code very easy to understand. The tibble gapminder is being piped into the function `filter()`. The argument `year == 2007` tells filter() that it should find all the rows such that the logical condition `year == 2007` is TRUE.

   ` Have we accidently deleted all other rows? Answer is no.` 
    
Nope: we haven't made any changes to gapminder at all. If you don't believe me try entering gapminder at the console. All that this command does is display a subset of gapminder. If we wanted to store the result of running this command, we'd need to assign it to a variable, for example if you are not sure, lets type

```{r tables}
gapminder %>% filter(year==2007)

```

## Filtering with respect to two variables

One can apply multiple `filters`

```{r}
gapminder %>% filter(year==2007,country=="Sri Lanka")

gapminder %>% filter(year==2007, country=="Pakistan")

```

Now we are selecting multiple countries for year 2007.

```{r}
gapminder %>% filter(year==2007, country %in% c("India", "Pakistan","Bangladesh", "Afghanistan", "Iran"))
```


## Filtering data for South Asia countries

```{r}
gapminderSA<-gapminder %>% filter(country %in% c("Bangladesh","India","Pakistan","Sri Lanka","Nepal", "Afghanistan","Bhutan", "Maldives"))
gapminderSA
```

## Sort data with `arrange`

Sort data with arrange Suppose we wanted to sort gapminder data for South Asia by gdpPercap. To do this we can use the arrange command along with the pipe %\>% as follows:

```{r}
gapminderSA %>% arrange(gdpPercap)

```

The logic is very similar to what we saw above for filter. Here, I use another important function `arrange`. The argument `gdpPercap` tells `arrange()` that we want to sort by GDP per capita. Note that by default `arrange()` sorts in ascending order. If we want to sort in descending order, we use the function `desc()`.

```{r}
gapminderSA %>% arrange(desc(gdpPercap))
```

## Life Expectancy in South Asia in 2007

What is the lowest and highest life expectancy among South Asian countries?

```{r}
gapminderSA %>% filter(year==2007) %>%  arrange(lifeExp)
```

## Change an existing variable or create a new one with mutate

It's a little hard to read the column pop in gapminder since there are so many digits. Suppose that, instead of raw population, we wanted to display population in millions. This requires us to pop by 1000000, which we can do using the function `mutate()` from dplyr as follows:

```{r}
gapminderSA %>% mutate(pop=pop/1000000)
```

If we want to calculate GDP, we need to multiply gdpPercap by pop.    

    But wait! Didn't we just change pop so it's expressed in millions? 
No: we never stored the results of our previous command, we simply displayed them. Just as I discussed above, unless you overwrite it, the original gapminder dataset will be unchanged. With this in mind, we can create the gdp variable as follows:

```{r}
gapminderSA %>% mutate(gdp = pop * gdpPercap)
```

## How to calculate new variables
As mentioned above, `mutate` is used to calculate new variable. Here we have calculated a new variable `gdp` and then `arranged` data and selected `top_n(10)` countries to see whether higher `lifeExpectancy` and higher `gdp` are linked or not? 

```{r top-10}
gapminder %>% filter(year==2007) %>% 
  mutate(gdp=gdpPercap*pop) %>% 
  arrange(desc(gdp)) %>% 
  top_n(10)

```

 `transmute()` keeps only the derived column. Let's use it in the example from above:

```{r }
gapminder %>% filter(year==2007) %>% 
  transmute(gdp=gdpPercap*pop) %>% 
  arrange(desc(gdp)) %>% 
  top_n(10)

```

## Ordering

If one wants to have ordered data with respect to specific column(s), `arrange()` function is used in dplyr. To arrange data by life expectancy, we use `arrange()` function

```{r}
gapminder %>% 
  select(country, year,lifeExp) %>% 
  filter(year==2007) %>% 
  arrange(lifeExp)

```

If one wants order from top to bottom, then use `arrange(desc())` command as follows:

```{r}
gapminder %>% 
  select(country, year,lifeExp) %>% 
  filter(year==2007) %>% 
  arrange(desc(lifeExp))

```

If one wants that only top 5 or bottom 5 rows are returned. One may use

```{r}
gapminder %>% 
  select(country, year,lifeExp) %>% 
  filter(year==2007) %>% 
  arrange(desc(lifeExp)) %>% 
  top_n(5)

```

```{r}
gapminder %>% 
  select(country, year,lifeExp) %>% 
  filter(year==2007) %>% 
  arrange(lifeExp) %>% 
  top_n(10)

```

 
# Summarising data

Another feature of dplyr is `summarise` data

```{r}
gapminder %>% filter(year==2007) %>% group_by(continent) %>% summarise(mean=mean(lifeExp),min=min(lifeExp),max=max(lifeExp))
```


```{r}
gapminder %>% 
  summarise(avglifeExp=mean(lifeExp))

```

## Summarising data by groups

```{r}
gapminder %>%
  filter(year == 2007, continent == "Asia") %>%
  summarize(avgLifeExp = mean(lifeExp)) 

```

```{r}
gapminder %>% 
  group_by(continent) %>% 
  filter(year==2007) %>% 
  summarize(avglife=mean(lifeExp))

```

## if_else command alongwith mutate

```{r}
gapminder %>%
  filter(year == 2007) %>%
  group_by(continent) %>%
  summarize(avgLifeExp = mean(lifeExp)) %>%
  mutate(over75 = if_else(avgLifeExp > 70, "Y", "N"))

```

## Total Population by Continets in 2007

```{r}
gapminder %>% 
  filter(year==2007) %>% 
  group_by(continent) %>% 
  summarize(tot_pop=sum(pop)) 

```

## Percentiles

In general it is assumed that higher the GDP , higher the lifeExp. To test this assumption, lets calculate percentiles of lifeExp. This will indicate how many countries have ranking lower than the current country.

```{r}
gapminder %>% select(country,year, lifeExp, gdpPercap) %>% 
  filter(year == 2007) %>%
  mutate(percentile = ntile(lifeExp, 100)) %>%
  arrange(desc(gdpPercap))
```

One can notice that all countries are well above 60th percentile on lifeExpectancy when arranged by GDP per capita.

Before you conclude, lets see the bottom side

```{r}
gapminder %>% select(country,year, lifeExp, gdpPercap) %>% 
  filter(year == 2007) %>%
  mutate(percentile = ntile(lifeExp, 100)) %>%
  arrange(gdpPercap)
```

So it makes sense that higher the GDP, higher the lifeExp. This is not formal testing but exploratory data makes lot of sense here.

# Advanced Analysis

Filtering data as done in introductory analysis seems quite difficult if you are not familiar with these simple things. But if you are working with dplyr for quite sometime, there is not anything very advanced or difficult.

For example, let's say you have to find out the top 10 countries in the 90th percentile regarding life expectancy in 2007. You can reuse some of the logic from the previous sections, but answering this question alone requires `multiple filtering` and `subsetting`:

```{r}
gapminder %>% filter(year==2007) %>% 
  mutate(percentile=ntile(lifeExp,100)) %>% 
  filter(percentile>90) %>% 
  arrange(desc(percentile)) %>% 
  top_n(10,wt=percentile) %>% 
  select(country,continent,lifeExp,gdpPercap)

```

In case you are interested in bottom 10 (worst lifeExp countries from the bottom), use `top_n` with `-10`.

```{r}
gapminder %>% filter(year==2007) %>% 
  mutate(percentile=ntile(lifeExp,100)) %>% 
  filter(percentile<10) %>% 
  arrange(percentile) %>% 
  top_n(-10,wt=percentile) %>% 
  select(country,continent,lifeExp,gdpPercap)
  

```

# Visualizing data to get data insight
Visualizing data is one of the most important aspect of getting data insight and may provide a better data insight than a complicated model. Visualizing large data sets were not an easy task, so researchers relied on mathematical and core econometric/regression models. `ggplot2` which is a set of `tidyverse` package is probably one of the greatest tool for data visualization used in `R`. In the following sections we are going to visualize `gapminder` data.

Stat graphics is a mapping of variable to `aes`thetic attributes of `geom`etric objects.

## 3 Essential components of `ggplot2`

-   data: dataset containing the variables of interest
-   geom: geometric object in question line, point, bars
-   aes:  aesthetic attributes of an object x/y position, colors, shape, size

## Scatter plot

```{r}

gapminder2007<-gapminder %>% filter(year==2007)
p1<-ggplot(data=gapminder2007,mapping = aes(x=gdpPercap,y=lifeExp,color=continent,size=pop))+geom_point()
p1+facet_wrap(~continent)
p1+  labs(x = "GDP Per Capita", y = "Life Expectancy in Years",
       title = "Economic Growth and Life Expectancy",
       subtitle = "Data points are country-years",
       caption = "Source: Gapminder.")

```


## Bubbleplot


```{r echo=FALSE}
# Show a bubbleplot

data <- gapminder %>% filter(year=="2007") %>% select(-year)

data %>%
  mutate(pop=pop/1000000) %>%
  arrange(desc(pop)) %>%
  mutate(country = factor(country, country)) %>%
  ggplot( aes(x=gdpPercap, y=lifeExp, size = pop, color = continent)) +
    geom_point(alpha=0.7) +
    scale_size(range = c(1.4, 19), name="Population (M)") +
    scale_color_viridis(discrete=TRUE, guide=FALSE) +
    theme_ipsum() +
    theme(legend.position="bottom")
```

If you just want to highlight the relationship between gbp per capita and life Expectancy you’ve probably done most of the work now. However, it is a good practice to highlight a few interesting dots in this chart to give more insight to the plot:


```{r}
# Prepare data
tmp <- data %>%
 mutate(
   annotation = case_when(
    gdpPercap > 5000 & lifeExp < 60 ~ "yes",
    lifeExp < 30 ~ "yes",
     gdpPercap > 40000 ~ "yes"
    )
) %>%
mutate(pop=pop/1000000) %>%
  arrange(desc(pop)) %>%
  mutate(country = factor(country, country))

# Plot
ggplot( tmp, aes(x=gdpPercap, y=lifeExp, size = pop, color = continent)) +
    geom_point(alpha=0.7) +
    scale_size(range = c(1.4, 19), name="Population (M)") +
    scale_color_viridis(discrete=TRUE) +
    theme_ipsum() +
    theme(legend.position="none") +
    geom_text_repel(data=tmp %>% filter(annotation=="yes"), aes(label=country), size=4 )
```



```{r}
##This is a table of data about a large number of countries, each observed over several years. Let's make a scatterplot with it.
P<-ggplot(data=gapminder,mapping = aes(x=gdpPercap,y=lifeExp))  

P+geom_point()+geom_smooth()

P+geom_point()+geom_smooth(method = "lm")

P+geom_point()+geom_smooth(method = "gam")+scale_x_log10()


P+geom_point()+geom_smooth(method = "gam")+scale_x_log10(labels=scales::dollar)


P<-ggplot(data=gapminder,mapping = aes(gdpPercap,y=lifeExp,color="purple"))
P+geom_point()+geom_smooth(method = "loess")+scale_x_log10()
```


```{r}
##aes() is for variables
P<-ggplot(data=gapminder,mapping = aes(gdpPercap,y=lifeExp))
P+geom_point(color="purple")+geom_smooth(method = "loess")+scale_x_log10()

P<-ggplot(data=gapminder,aes(x=gdpPercap,y=lifeExp))
P+geom_point(alpha=0.3)+
  geom_smooth(color="orange",se=FALSE,size=8,method = "lm")+
  scale_x_log10()


#With proper title
P<-ggplot(data=gapminder,mapping = aes(gdpPercap,y=lifeExp))
P+geom_point(alpha=0.3)+
  geom_smooth(method = "gam")+
  scale_x_log10(labels=scales::dollar)+
  labs(x = "GDP Per Capita", y = "Life Expectancy in Years",
       title = "Economic Growth and Life Expectancy",
       subtitle = "Data points are country-years",
       caption = "Source: Gapminder.")

```

```{r}
##Continent wise

p <- ggplot(data = gapminder,
            mapping = aes(x = gdpPercap,
                          y = lifeExp,
                          color = continent))
p + geom_point() +
  geom_smooth(method = "loess") +
  scale_x_log10()
```

```{r}
p <- ggplot(data = gapminder,
            mapping = aes(x = gdpPercap,
                          y = lifeExp,
                          color = continent,
                          fill = continent))
p + geom_point() +
  geom_smooth(method = "loess") +
  scale_x_log10()
```

```{r}
##Aesthetics can be mapped per geom
p <- ggplot(data = gapminder, mapping = aes(x = gdpPercap, y = lifeExp))
p + geom_point(mapping = aes(color = continent)) +
  geom_smooth(method = "loess") +
  scale_x_log10()


p + geom_point(mapping = aes(color = log(pop))) +
  scale_x_log10()  


```

## Comparison of 2007 vs 1952 continentwise

```{r}
gapminder2007<-gapminder %>% filter(year==2007)
p1<-ggplot(data=gapminder2007,mapping = aes(x=gdpPercap,y=lifeExp,color=continent,size=pop))+geom_point()
cont_2007<-p1+facet_wrap(~continent)+ylim(0,90)  

gapminder1952<-gapminder %>% filter(year==1952)
p11<-ggplot(data=gapminder1952,mapping = aes(x=gdpPercap,y=lifeExp,color=continent,size=pop))+geom_point()
cont_1952<-p11+facet_wrap(~continent)+ylim(0,90)
library(gridExtra)
grid.arrange(cont_1952,cont_2007,nrow=1)

```

```{r}
p1+labs(x = "GDP Per Capita", y = "Life Expectancy in Years",
       title = "Economic Growth and Life Expectancy",
       subtitle = "Data points are country-years",
       caption = "Source: Gapminder.")


```
