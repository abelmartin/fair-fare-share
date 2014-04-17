# Introduction
At the end night with friends, taking a cab is common.

Typically the amount a rider owes during the trip gets calculated with weird math as dropped offs.

This [Gothamist article](http://gothamist.com/2005/12/09/_the_economics.php) summarizes this [WSJ article's split strategies](http://online.wsj.com/news/articles/SB113279169439805647) well.  Given 3 riders(A,B & C):

- trip-leg
- proportional-savings
- game-theories
- Talmudic

Typically, my friends and I don't do any of this.  We most likely split the final fare by the number of humans in the car.

Is our 'even-split' method fair?  No, not really...but the first 'trip leg' strategy sounds awesome.

Every time the cab stops, all riders in the cab split the cost up to that point.  Let's assume Alan, Beth & Carl (A, B & C) take a cab

If the total cab fare was $100 and ...
 - At Alan's stop, 30% of the trip, the fair => $30 / 3 => A,B, & C contribute $10   -- OR -- Alan pays $5 to both Beth & Carl
 - At Beth's stop, 50% of the trip, the fair => $50 / 2 => B & C contribute $25      -- OR -- Beth pays Carl $40 after getting $5 from Alan
 - At Carl's stop, 20% of the trip, the fair => $20 / 1 => C delivers contributions  -- OR -- Carl pays $100 after getting $5 from Alan & $40 from Beth

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

- Auto fare calculations assuming perfect traffic conditions.
- A map showing the routes taken. (It's good to see what routes are assumed)
- Adding time taken between stops.  (Following the perfect route doesn't take traffic into account)
- Venmo integration to make getting payment easier. (Get your money :bowtie:)

Other feaures, if desired, should/will be added as issues to this repo :sunglasses: