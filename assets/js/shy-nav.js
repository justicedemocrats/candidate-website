const ShyNav = {

    init: function(nav) {
        this.nav = document.getElementById(nav);

        // initialize nav position
        this.setInlineOrSticky();

        // attached events to onScroll
        this.setScrollCalls();
    },


    /**
     * Bool, true if last scroll direction was down. Set
     * in setScrollCalls.
     */
    isScrollingDown: false,


    /**
     * Set classes if nav is visible & scrolling direction
     */
    setInlineOrSticky: function() {

        // set scrolling direction
        if (this.isScrollingDown)
        {
            this.addClass('scrolling-down');
            this.removeClass('scrolling-up');
        }
        else
        {
            this.addClass('scrolling-up');
            this.removeClass('scrolling-down');
        }

        // set whether nav is visible
        if (this.isVisible())
        {
            this.addClass('nav-visible');
            this.removeClass('nav-hidden');
        }
        else
        {
            this.addClass('nav-hidden');
            this.removeClass('nav-visible');
        }

    },


    /*
     * Add class to HTML
     */
    addClass: function(to_add)
    {
        var html = document.getElementsByTagName("HTML")[0];
        
        if (to_add == undefined) return;

        html.className += ' ' + to_add; 
    },



    /*
     * Remove class from HTML
     */
    removeClass: function(to_remove)
    {
        var html = document.getElementsByTagName("HTML")[0];
        
        if ( to_remove == undefined) return;
        
        var htmlClass = ' ' + html.className + ' ';

        while(htmlClass.indexOf(' ' + to_remove + ' ') !== -1) {
             htmlClass = htmlClass.replace(' ' + to_remove, ' ');
        }

        html.className = htmlClass;
    },


    /**
     * Update scroll direction & apply classes
     */
    setScrollCalls: function() {
        var self = this;
        var lastScrolltop = 0;
        var setClasses = this.setInlineOrSticky.bind(this);
        
        window.onscroll = function(e) {
            var scrollTop = this.scrollY;

            self.isScrollingDown = scrollTop > lastScrolltop;
            lastScrolltop = scrollTop;
            
            setClasses();
        }
    },


    // detections

    /**
     * Determines if screen is above nav.
     */
    isVisible: function() {
        const box = this.nav.getBoundingClientRect();

        return box.top >= 0 &&
               box.bottom <= (window.innerHeight || document.documentElement.clientHeight);
    }


}

export { ShyNav }
