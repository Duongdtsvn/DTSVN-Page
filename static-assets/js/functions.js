(function($) {
	"use strict";
	window.isIE = /(MSIE|Trident\/|Edge\/)/i.test(navigator.userAgent);
	window.windowHeight = window.innerHeight;
	window.windowWidth = window.innerWidth;

    if (history.scrollRestoration) {
        history.scrollRestoration = 'auto';
    }
	
	// Returns a function, that, as long as it continues to be invoked, will not
    // be triggered. The function will be called after it stops being called for
    // N milliseconds. If `immediate` is passed, trigger the function on the
    // leading edge, instead of the trailing.
    function debounce(func, wait, immediate) {
        var timeout;
        return function() {
            var context = this, args = arguments;
            var later = function() {
                timeout = null;
                if (!immediate) func.apply(context, args);
            };
            var callNow = immediate && !timeout;
            clearTimeout(timeout);
            timeout = setTimeout(later, wait);
            if (callNow) func.apply(context, args);
        };
    };

    function numberLineTextJs() {
        function reInit(el, number, fix) {
            var fontSize = parseInt(el.css('font-size')),
                lineHeight = parseInt(el.css('line-height')),
                overflow = fontSize * (lineHeight / fontSize) * number;
        
            el.css({
                'display': 'block',
                'display': '-webkit-box',
                '-webkit-line-clamp': String(number),
                '-webkit-box-orient': 'vertical',
                'overflow': 'hidden',
                'text-overflow': 'ellipsis'
            });
            
            if (fix == 'true') {
                el.css('height', overflow);
            }
        }

        $('[data-textLine="full"]').each(function() {
            var self = $(this),
                getNumber = self.attr('date-number') ? self.attr('date-number') : 2,
                getFix = self.attr('data-fixheight') ? self.attr('data-fixheight') : 'false';
            reInit(self, getNumber, getFix);
        });
        
        if(device.mobile()) {
            $('[data-textLine="mb"]').each(function() {
                var self = $(this),
                    getNumber = self.attr('date-number') ? self.attr('date-number') : 2,
                    getFix = self.attr('data-fixheight') ? self.attr('data-fixheight') : 'false';
                reInit(self, getNumber, getFix);
            });
        }else if(device.tablet()) {
            $('[data-textLine="tl"]').each(function() {
                var self = $(this),
                    getNumber = self.attr('date-number') ? self.attr('date-number') : 2,
                    getFix = self.attr('data-fixheight') ? self.attr('data-fixheight') : 'false';
                reInit(self, getNumber, getFix);
            });
        }else {
            $('[data-textLine="pc"]').each(function() {
                var self = $(this),
                    getNumber = self.attr('date-number') ? self.attr('date-number') : 2,
                    getFix = self.attr('data-fixheight') ? self.attr('data-fixheight') : 'false';
                reInit(self, getNumber, getFix);
            });
        }
    }
    
    function wowJs() {
        if($(window).width() < 768) {
            $('.wow-mb').each(function() {
                $(this).addClass('wow');
            });
        }

        var wow = new WOW({
            boxClass:     'wow',      // animated element css class (default is wow)
            animateClass: 'animated', // animation css class (default is animated)
            mobile:       true,       // trigger animations on mobile devices (default is true)
            live:         true,       // act on asynchronously loaded content (default is true)
            callback:     function(box) {
                $(box).addClass('effect');
                $(box).removeClass('fix');
            },
            scrollContainer: null // optional scroll container selector, otherwise use window
        });
        wow.init();
    }
    
    function dataImageMobileUrl() {
        var update = function() {
            var ww = $(window).width();
            if(ww < 768) {
                $('[data-img-mb').each(function() {
                    var self = $(this),
                        url = self.attr('data-img-mb');
                    self.attr('src', url);
                });
    
                $('[data-bg-mb').each(function() {
                    var self = $(this),
                        url = self.attr('data-bg-mb');
                    self.css('background-image', 'url('+url+')');
                });
            }else {
                $('[data-img-pc]').each(function() {
                    var self = $(this),
                        url = self.attr('data-img-pc');
                    self.attr('src', url);
                });
    
                $('[data-bg-pc]').each(function() {
                    var self = $(this),
                        url = self.attr('data-bg-pc');
                    self.css('background-image', 'url('+url+')');
                });
            }
        }
        update();
        $(window).on('resize', debounce(update, 200));
    }

    function backtotopJs() {
        var id = $('#backtotop');
        var update = function() {
            var wh = $(window).height() / 2,
                scroll = $(window).scrollTop();
        
            if( scroll > wh ) {
                id.addClass('active');
            }else {
                id.removeClass('active');
            }
        }
        update();
        $(window).on('scroll', update);
        id.on('click', function (e) {
            e.preventDefault();
            $('html,body').animate({
                scrollTop: 0
            }, 700);
        });
    }


    function headerJs() {
        var header = $('.header');
        
        if(header.length) {
            var headeroom = new Headroom(document.querySelector("header"), {
                tolerance : 4,
                offset : 100,
                classes: {
                    pinned: "header-pin",
                    unpinned: "header-unpin"
                },
                onPin : function() {
                },
                // callback when unpinned, `this` is headroom object
                onUnpin : function() {
                },
            });
            headeroom.init();
        }
        
        var btnToggle = ()=> {
            var tl = new TimelineMax({paused: true});
            tl.addLabel('start')
            tl.to('.header__humberger .icon-1', 0.3, {y: 6});
            tl.to('.header__humberger .icon-3', 0.3, {y: -6}, 'start');
            tl.to('.header__humberger .icon-1', 0.3, {rotation: 45},);
            tl.to('.header__humberger .icon-3', 0.3, {rotation: -45}, '-=0.3');
            tl.to('.header__humberger .icon-2', 0.1, {autoAlpha: 0}, 'start+=0.3');
            tl.to('.menuMobile',0.1, {autoAlpha: 1}, 'start+=0.3');
            tl.to('.menuMobile',0.5, {x: '0%'}, 'start+=0.5');
            
            $('.header__humberger').on('click', function(e) {
                e.preventDefault();
                if( header.hasClass('open-menu')) {
                    tl.reverse().time(1);
                    setTimeout(function(){
                        header.removeClass('open-menu');
                    }, 600);
                }else {
                    tl.play();
                    setTimeout(function(){
                        header.addClass('open-menu');
                    }, 1000);
                }
            });
        }
        btnToggle();
    }
    
    function heroScrollJs() {
        if ( $('.sec-hero').length ) {
            ScrollTrigger.create({
                trigger: '.sec-hero',
                start: "top top",
                end: "bottom top",
                // markers: true,
                scrub: 1,
                onUpdate: function(e) {
                    var progress = e.progress.toFixed(3);
                    TweenMax.set('.sec-hero .swiper-container', {y: (progress*100)+'%', ease:Linear.easeNone});
                    TweenMax.set('.sec-hero .sec-hero__inner', {autoAlpha: 1-(progress*5), ease:Linear.easeNone});
                }
            });
        }
    }

    function parallaxBg() {
        $('[data-parallax="bg"]').each(function() {
            var self = $(this);
            var getClassTrigger = self.attr('data-trigger');
            var getRevest = self.attr('data-revest');
            var domTrigger = self.closest(getClassTrigger);
            var getHeight1 = $(domTrigger).height();
            var getHeight2 = $(self).height();
            var total = getHeight2 - getHeight1;
            var vertical = -1;

            if(getRevest == '-1') {
                vertical = 1;
            }

            ScrollTrigger.create({
                trigger: domTrigger[0],
                start: "top bottom",
                end: "bottom top",
                // markers: true,
                scrub: 1,
                animation: TweenMax.to(self[0], {y: (total)*vertical })
            });
        });
    }

    function memberBoxSlideJs() {
        var wrapper =  $('.sec-memberBox');
        if(wrapper.length) {
            var owlImg = wrapper.find('.sec-memberBox__img');
            var owlMenu = wrapper.find('.sec-memberBox__list ');
            var owlText = wrapper.find('.sec-memberBox__text');

            var svgSlideJs = function() {
                // owlImg.owlCarousel({
                //     items: 1,
                //     loop:true,
                //     smartSpeed: 0,
                //     dots: false,
                //     nav: false,
                //     touchDrag: false,
                //     mouseDrag: false,
                //     // autoplay: true,
                //     autoplayTimeout: 8000,
                //     autoplayHoverPause:true
                // });
                // var getIndex = owlImg.find('.owl-item.active .item').attr('data-index');
                // // owlText.find('.item[data-index="'+getIndex+'"]').addClass('active');

                // owlImg.on('change.owl.carousel', function(event) {
                //     owlImg.trigger('stop.owl.autoplay');
                // });

                // owlImg.on('changed.owl.carousel', function(event) {
                //     setTimeout(function(){
                //         var getIndex = owlImg.find('.owl-item.active .item').attr('data-index');
                //         if ($(window).width() > 767) {
                //                 owlMenu.find('.item').removeClass('current');
                //                 owlMenu.find('.item[data-index="'+getIndex+'"]').addClass('current');
                //                 owlText.find('.item').removeClass('active');
                //                 owlText.find('.item[data-index="'+getIndex+'"]').addClass('active');
                //         }else {
                //             owlMenu.trigger('to.owl.carousel', [getIndex, 500]);
                //             owlMenu.find('.item').removeClass('current');
                //             owlMenu.find('.item[data-index="'+getIndex+'"]').addClass('current');
                //             owlText.find('.item').removeClass('active');
                //             owlText.find('.item[data-index="'+getIndex+'"]').addClass('active');
                //         }
                //     },1);
                //     setTimeout(function() {
                //         owlImg.trigger('play.owl.autoplay');
                //     }, 100);
                // });
            }
            svgSlideJs();

            var listMenu =  function() {
                var checkWidth = $(window).width();
                if(checkWidth < 991) {
                    var total = 0;
                    owlText.find('.item').each(function() {
                        var self = $(this);
                        var getHeight = self.height();
                        if (total > getHeight ) {
                            
                        }else {
                            total = getHeight;
                        }
                    });
                    owlText.find('.item').css('min-height', total);
                }else {
                    owlText.find('.item').removeAttr('style');
                }

                if (checkWidth > 767) {
                    setTimeout(function() {
                        owlMenu.find('.item').removeAttr('style');
                        if (typeof owlMenu.data('owl.carousel') != 'undefined') {
                            owlMenu.data('owl.carousel').destroy();
                        }
                        owlMenu.removeClass('owl-carousel');
                        // owlMenu.find('.item').eq(0).addClass('current');
                        owlMenu.find('.item').on('click', function() {
                            var self = $(this);
                            
                            if( !self.hasClass('active') ) {
                                var getIndex = self.attr('data-index');
                                owlMenu.find('.item').removeClass('current');
                                owlMenu.find('.item[data-index="'+getIndex+'"]').addClass('current');
                                owlText.find('.item').removeClass('active');
                                owlText.find('.item[data-index="'+getIndex+'"]').addClass('active');
                                // owlImg.trigger('to.owl.carousel', [getIndex, 0]);
                            }
                        });
                    }, 50)
                } else {
                    setTimeout(function() {
                        owlMenu.find('.item').each(function() {
                            var self = $(this);
                            self.css('width', self.width());
                        });
                        
                        owlMenu.addClass('owl-carousel');
                        owlMenu.owlCarousel({
                            items: 3,
                            slideSpeed: 500,
                            dots: false,
                            nav: false,
                            autoWidth: true,
                            margin: 40,
                        });

                        owlMenu.find('.owl-item.active .item').eq(0).addClass('current');
                        owlText.find('.item').eq(0).addClass('active');
                        owlMenu.find('.owl-item').on('click', function() {
                            var self = $(this);
                                var getIndex = self.find('.item').attr('data-index');
                                owlMenu.trigger('to.owl.carousel', [getIndex, 500]);
                                owlMenu.find('.owl-item .item').removeClass('current');
                                self.find('.item').addClass('current');
                                owlText.find('.item').removeClass('active');
                                owlText.find('.item[data-index="'+getIndex+'"]').addClass('active');
                            // if( !self.hasClass('center') ) {
                            // }
                        });
                    }, 50);
                }
            }  
            listMenu();
            $(window).resize(listMenu);
        }
    }

    function partnershipsBoxList() {
        var wrap = $('.partnershipsBox__list');
        if(wrap.length) {
            var update = function() {
                var ww = $(window).width();
                var item =  wrap.find('.item');
                var text = item.find('.item__text');

                if ( ww >= 768 ) {
                    setTimeout(function() {
                        item.removeClass('hover');
                        text.removeAttr('style');
                        item.off('click');
                        item.each(function() {
                            var self = $(this);
                            var getHeight = self.find('.item__text').outerHeight();
                            self.find('.translate').css('--y', getHeight+'px');
                        });
                    }, 100);
                    
                }else {
                    item.on('click', function() {
                        var self = $(this);
                        if( self.hasClass('hover') ) {
                            self.removeClass('hover');
                        }else {
                            item.removeClass('hover');
                            text.slideUp();
                            self.addClass('hover');
                            self.find('.item__text').slideDown();
                        }
                    });
                }
            }
            update();
            $(window).on('resize', debounce(update, 400))
        }
    }

    function translateBox() {
        var update = function() {
            $('[data-translate]').each(function() {
                var self = $(this),
                    getDom = self.find(self.attr('data-translate'));
                
                getDom.css('visibility', 'hidden');
                setTimeout(function() {
                    var getHeight = getDom.outerHeight();
                    self.css('--y', getHeight+'px');
                    getDom.css('visibility', 'visible');
                }, 100);

            });
        }
        update();
        $(window).on('resize', debounce(update, 300));
    }

    function strengthJs() {
        var wrapper =  $('.sec-strength');
        if(wrapper.length) {
            var owlMenu = wrapper.find('.sec-strength__list');

            var slideMobile =  function() {
                var checkWidth = $(window).width();

                if (checkWidth > 767) {
                    setTimeout(function() {
                        if (typeof owlMenu.data('owl.carousel') != 'undefined') {
                            owlMenu.data('owl.carousel').destroy();
                        }
                        owlMenu.removeClass('owl-carousel');
                        if( !owlMenu.find('.item').hasClass('item-2') ) {
                            owlMenu.prepend('<div class="item item-2"></div>');
                        }
                    }, 50)
                } else {
                    owlMenu.find('.item-2').remove();
                    owlMenu.addClass('owl-carousel');
                    setTimeout(function() {
                        owlMenu.owlCarousel({
                            items: 1,
                            smartSpeed: 500,
                            dots: false,
                            nav: false,
                            margin: 17,
                        });
                    }, 50);
                }
            }  
            slideMobile();
            $(window).on('resize', debounce(slideMobile, 200));
        }
    }
    
    function teamLeaderSlideJs() {
        var wrapper =  $('.sec-teamLeader__slide');
        
        if(wrapper.length) {
            var slide = wrapper.find('.owl-carousel');
            var getBig = wrapper.closest('.sec-teamLeader__content').find('.teambox.big');
            
            var update = function() {
                var ww = $(window).width();
                if (typeof slide.data('owl.carousel') != 'undefined') {
                    slide.data('owl.carousel').destroy();
                }

                if( ww > 1200 ) {
                    wrapper.find('.item').each(function(index) {
                        if (index % 2 == 0) { // wrap by 2 items
                            $(this).add($(this).next('.item')).wrapAll('<div class="item__col"></div>');
                        }
                    });
                }

                if( ww > 991) {
                    slide.find('.teambox.big').parent().remove();
                }else {
                    setTimeout(function() {
                        wrapper.find('.item__col').each(function(index) {
                            $(this).find('.item').unwrap();
                        });

                    }, 100);
                    if( !slide.find('.teambox').hasClass('.big') ) {
                        slide.prepend('<div class="item">'+getBig[0].outerHTML+'</div>');
                    }
                }
                setTimeout(function() {
                    slide.owlCarousel({
                        items: 1,
                        smartSpeed: 500,
                        dots: false,
                        nav: true,
                        margin: 16,
                        navText: ['<span></span> Quay lại', 'Tiếp tục <span></span>'],
                        responsive : {
                            // breakpoint from 768 up
                            768 : {
                                margin: 30,
                                items: 2
                            },
                            1200 : {
                                margin: 30,
                                items: 2
                            }
                        }
                        
                    });
                }, 200);
            }
            update();
            $(window).on('resize', debounce(update, 200));
        }
    }

    function stickyJs() {
        $('.stickyJs .sticky').theiaStickySidebar({
            additionalMarginTop: 80,
            minWidth: 1200
        });
    }

    function teamInfoClientHover() {
        var wrap = $('.sec-teamInfo__client');
        if(wrap.length) {
            var fix = function() {
                var getHeight = wrap.find('.item-logo__hover').height();
                
                wrap.find('.item').hover(
                    function() {
                        wrap.css('padding-bottom', getHeight);
                    }, function() {
                        wrap.css('padding-bottom', 0);
                    }
                );
            }
            fix();
            $(window).on('resize', debounce(fix, 200));
        }
    }

    function popupTeamJs() {
        var item = $('.btn-popupTeam'),
            bg = $('.modal-team__bg'),
            close = $('.modal-team__close');

        item.on('click', function(e) {
            e.preventDefault();

            var self = $(this),
            getName = self.find('.teambox__name').text(),
            getPosition= self.find('.teambox__text').text(),
            getImage = self.find('.teambox__img').attr('style'),
            getList = self.find('.teambox__list').html(),
            getId = self.attr('href');

            $(getId).find('.modal-team__img').attr('style', getImage);
            $(getId).find('.modal-team__subtitle').text(getPosition);
            $(getId).find('.modal-team__title').text(getName);
            $(getId).find('.modal-team__list').html(getList);
            $(getId).addClass('show');
        });

        bg.on('click', function() {
            $(this).closest('.modal-team').removeClass('show');
        });

        close.on('click', function() {
            $(this).closest('.modal-team').removeClass('show');
        });
    }


    // call new
    headerJs();
    dataImageMobileUrl();
    memberBoxSlideJs();
    strengthJs();
    teamLeaderSlideJs();
    popupTeamJs();

    $(window).on('load', function() {
        $('body').addClass('body-load-done');
        numberLineTextJs();
        partnershipsBoxList();
        translateBox();
        stickyJs();
        teamInfoClientHover();
        wowJs();
    });
})(jQuery);