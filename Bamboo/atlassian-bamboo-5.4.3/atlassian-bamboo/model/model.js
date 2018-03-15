(function (BAMBOO) {
    BAMBOO.MODEL = {};
    BAMBOO.COLLECTION = {};
}(window.BAMBOO = (window.BAMBOO || {})));


BAMBOO.MODEL.Key = Brace.Model.extend({
      namedAttributes: {
          key: 'string'
      }
});

BAMBOO.MODEL.ResultKey = Brace.Model.extend({
      namedAttributes: {
          key: 'string',
          entityKey: BAMBOO.MODEL.Key,
          resultNumber: 'number'
      }
  });