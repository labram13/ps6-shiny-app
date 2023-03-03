Overview:

In this program, we analyze a data set collected from 2020-2021. The
data set contains information on loans taken out from students from all over
the U.S. It's structured to organize the data by school. In addition, we are able
to look at the different types of loans taken out and how many of those loans
were disbursed to students. There's plenty to look at in this data set. However,
I've only manipulated the data to find the average loans by state from all the 
colleges within those states. So we are able to see the highest to lowest
average loans per state. 

In terms of how the shiny app works, it is subset into three different panels.
The first panel is more so general information of the data with the amount of
data there is and how many columns there are. A random sample of the data
is also shown to get a better feel for what is present.

Our manipulated data is show in the second tab called plot. Here, we are able
to select the states to show there average loans taken out by students in
the form of a bar graph. The user is able to select more than one so they can 
compare and contrast many different states which is one of the widgets available. 
In terms of visuals, I've given the user the ability to choose different color 
palettes to fill the the bar graphs with. Color palettes were installed from the
package "viridis" so be sure to install it with install.packages("viridis").

In the third and final tab, we see a more uniform data table for the user
to visualize on that note. Only widget here is the user is able to organize
the data by highest average loan to lowest by selecting the one option. Table
is also intractable so they can find a certain state if need be!


