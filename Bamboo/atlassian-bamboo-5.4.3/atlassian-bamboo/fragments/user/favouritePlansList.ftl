<div class="favourites-plan-list">
    <h2>[@ww.text name='dashboard.wallboard.favourite'/]</h2>
    [@ww.url id='myFavouritesUrl' namespace='/ajax' action='myFavourites' /]
    [@dj.reloadPortlet url='${myFavouritesUrl}' id='myFavourites' reloadEvery=30]
    [@ww.action name='myFavourites' namespace='/ajax' executeResult='true' /]
    [/@dj.reloadPortlet]
</div>
