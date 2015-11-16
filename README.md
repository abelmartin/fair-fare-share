# Introduction
At the end night with friends, taking a cab is common.

This [Gothamist article](http://gothamist.com/2005/12/09/_the_economics.php) summarizes this [WSJ article's split strategies](http://online.wsj.com/news/articles/SB113279169439805647) well:

- trip-leg
- proportional-savings
- game-theories
- Talmudic

My friends and I don't do any of this.  Typically, we split the fare by the number of humans in the car along with drunk approximations of distance & cost.

Is it fair?  Well, sorta :sweat_smile: ... but the 'trip-leg' strategy sounds like an awesome replacement.  Every time the cab stops, all riders in the cab split the cost up to that point.

Let's assume **A**lan, **B**eth & **C**arl take a cab where the total cab fare was $100:

 - At Alan's stop, 30% of the trip, the fair => $30 / 3 => A,B, & C contribute $10 to the 'pot' -- OR -- Alan pays $5 to both Beth & Carl
 - At Beth's stop, 50% of the trip, the fair => $50 / 2 => B & C contribute $25 to the 'pot' -- OR -- Beth pays Carl $40 after getting $5 from Alan
 - At Carl's stop, 20% of the trip, the fair => $20 / 1 => C delivers the pot & his final contribution of $20 -- OR -- Carl pays $100 after getting $5 from Alan & $40 from Beth

...with final totals of:
- Alan paying $10 instead of $30 by himself
- Beth paying $35 instead of $50 by herself
- Carl paying $55 instead of $100 by himself

FFS helps you calculate your shares based on the 'trip-leg' theory.

# FAQ
FFS...
- is VERY NYC focused on standard (non MTA strike) days.  FFS does not consider any zones
- doesn't take any special rules (like airport or [group ride](http://www.nyc.gov/html/tlc/html/passenger/taxicab_rate.shtml) flat fees) into account.
- doesn't take traffic into account.  If the Westside Highway becomes a parking lot cost percentages get weird in this version.

# Roadmap
FFS is very much a work in progress with more features coming like...

- WIP: Removing the ugly blue report box :sweat_smile:
- Auto fare calculations assuming perfect traffic conditions.
- A map showing the routes taken. (It's good to see what routes are assumed)
- Adding time taken between stops.  (Following the perfect route doesn't take traffic into account)
- Venmo integration to make getting payment easier. (Get your money :bowtie:)

Other feaures, if desired, should/will be added as issues to this repo :sunglasses: