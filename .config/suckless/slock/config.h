/* user and group to drop privileges to */
static const char *user  = "daksh";
static const char *group = "wheel";

static const char *colorname[NUMCOLS] = {
	[BG] =     "black",     /* background */
	[INIT] =   "black",     /* after initialization */
	[INPUT] =  "#ebdbb2",   /* during input */
	[FAILED] = "#CC3333",   /* wrong password */
};

/* treat a cleared input like a wrong password (color) */
static const int failonclear = 1;

/* size of square in px */
static const int squaresize = 20;

/* spacing between squares in px */
static const int squarespacing = 10;
