# iOS-Battlefront2-Balancing
This is a personal project that I'm working on to tackle the balancing issues in the new Battlefront 2 game.

### The Objective
The objective of this project is to get EA/DICE to look at the logic from the project and get them to implement these changes server side in their matchmaking logic. One of the biggest problems that still exists in Battlefront 2 is that multiplayer team play is inherently unbalanced. It's a self-perpetuating problem as well because losing teams typically quit the game while those on the winning side typically stay. My objective was to make a general solution to this problem and generate enough support and interest from the community that EA and DICE would use this match balancing logic from this project to fix their current game.

### The Problem
There are a number of reasons that this problem exists from a player’s perspective.

The first one was mentioned above where the losing teams continue to lose because they have a high turnover rate and the nature of the game is such that one random excellent player that joins a losing team can't carry his team to a win because of the sheer number of players in a game mode like Galactic Assault. This self-perpetuating problem leads to very frustrated players that either grind through games just to level up characters or those that quit in frustration. I've found that this problem also affects the winning teams experience because they either get board of playing a weaker team or they feel bad for trouncing them round after round.

I think that the underlying cause of this problem is the Battle Team system. A Battle Team is a group of friends that can stick together and play on the same team. Because there is no rearranging of the teams (except by the natural churn) and absolutely no splitting up of Battle Teams it can lead to a very uneven and unpleasant experience. Battle Teams made up of very experienced players are definitely the largest contributor to this problem because they can stay together game after game and never get split up. Battle Teams with lower experience players can also influence this problem because they can fill up a losing team and make it hard for experienced players/teams to join and help them. These Battle Teams can be a problem in every game mode but are especially devastating in Heroes vs. Villains where a 4 player Battle Team can absolutely destroy newer players trying to level up their heroes.

I understand that Battle Teams are an important feature to the game because multiplayer is inherently team/friend based. My experience on Battlefront 2 is almost entirely me playing with my wife, so I understand that playing with your friends is important. However, I think that a less strict rule for Battle Teams would allow a greater balance to the game exist and make it much more fun for everyone involved. That's where this project comes in.

### The Solution
This is just one of many approaches that have been suggested as solutions to this problem by the community. The basic idea of this algorithm is that after each map rotation EA or DICE whomever runs the severs could use this algorithm to rebalance the teams. This approach breaks the strict Battle Teams rule, but it does try and keep teams together whenever possible.

The way that it works is there is a score function that each player has. This score function is comprised of a player’s kills, kill death ratio, eliminations, battle points from completing objectives and battle points from using abilities. All of these values are normalized and then weighted by variables that can act as tuning parameters. For example, these weights might value completing objectives more when playing Galactic Assault or Strike, while kills would be more heavily weighted in the Blast. The tweaking of these values is one of the great features of this algorithm because it allows you to optimize balancing for different game modes.

With this score function created for each player based on their past few games, I've used the score generated for each player to put them into a Priority Queue that sorts them by their score, highest scored player on top. After each map rotation the rebalancing teams function could them be called and rebalance the teams based on their average score for the past few games. The way that the sorting works is that it takes the player with the highest score and puts them on the team with the lowest team score. It's a simple yet very effective way of balancing the teams.

In order to attempt to keep Battle Teams together whenever possible I implemented the following solution. If you are one of the first members of your Battle Team to be sorted into a team you are sorted as usual. Once you get to the last player on the battle team the algorithm will check if there are any teammates that are currently assigned to the projected team, if they are great, but if not, there are a couple of conditions that need to be met in order for that last Battle Team member to join his/her teammates on the team with the highest score. The first condition is that there need to be enough players left in the Priority Queue so that one half of the remaining players could compensate for that player being on the other team. The second condition is a check against the players normalized score. If that score is below a certain threshold then their points are insignificant enough to be on any team so they can join their teammates on the team with the highest score. This part of the algorithm isn't a guarantee that the players will always be together but it is an attempt to help a team stay together.

### Suggestions
As mentioned above this in only one of many solutions proposed by an awesome community. I understand that breaking up Battle Teams is a bit controversial but, in my opinion, removing that guarantee is the only way to truly fix this issue and even attempt any semblance of balance to the game. This project is my attempt at making one version of a solution that I hope gets considered or can even be used as a spring board for finding the real solution in the future. That said, I am open to suggestions for this algorithm, just not suggestions that change its entire premise.

### Contributions
In order to get this project to where I'd like it to be I'm open to having as many contributors who understand/want to learn iOS in order to make this project available to the masses. Anyone can (and I hope many will) clone this project and play around with it in XCode and hopefully make pull requests for improvements. I'd like to get it to the point where the app can change the game mode, the stats, and even the algorithm itself in order for other non-technical players of Battlefront 2 to be able to play around with it and compare different solutions and how they work.

If you're not interested in learning swift but would still like to contribute in the future I'm going to be creating a place where you can input your own stats for games which will improve the data that I'm using as an example. The other best thing that you can do if you're interested in helping with this project is to help this project gain traction in the Battlefront 2 community by trying to get EA/DICE's attention with the project so that they can actually see and use what's here so far. The forum tread that has been used so far is https://battlefront-forums.ea.com/discussion/comment/1072395.

Thanks in advance for the support. I hope that together we can bring balance to the Force.

"May the force be with you...always"
