<#import "/templates/system/common/crafter.ftl" as crafter />
<#import "/templates/system/common/commonHead.ftl" as common />

<!doctype html>
<html lang="en" class="demo">

<head>
   <@common.commonHead />
  <@crafter.head />
</head>

<body>
  <@crafter.body_top />
  <@crafter.renderComponentCollection $field="header_o" />
  <@crafter.renderComponentCollection $field="banner_home_o" />
  <@crafter.renderComponentCollection $field="products_o" />
  <@crafter.renderComponentCollection $field="member_o" />
  <@crafter.renderComponentCollection $field="partner_o" />
  <@crafter.renderComponentCollection $field="motto_o" />
  <@crafter.renderComponentCollection $field="achievements_o" />
  <@crafter.renderComponentCollection $field="leader_o" />
  <@crafter.renderComponentCollection $field="blog_o" />
  <@crafter.renderComponentCollection $field="footer_o" />
  <@crafter.body_bottom />
  <script src="/static-assets/js/header.js"></script>
  <script >
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
    popupTeamJs();
  </script>
</body>

</html>