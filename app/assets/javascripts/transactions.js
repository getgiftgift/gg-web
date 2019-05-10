$(document).on("ready", function() {
  var form = document.querySelector("#checkout-form");
  var submit = $("input[type='submit']");

  form &&
    braintree.client.create(
      {
        authorization: $(".hidden#token").val()
      },
      function(clientErr, clientInstance) {
        if (clientErr) {
          // do error stuff
          return;
        }
        braintree.hostedFields.create(
          {
            client: clientInstance,
            styles: {
              input: {
                color: "#7d7d7d",
                "font-size": ".875rem"
              }
            },
            fields: {
              number: {
                selector: "#card-number",
                placeholder: "4111 1111 1111 1111"
              },
              cvv: {
                selector: "#cvv",
                placeholder: "123"
              },
              expirationDate: {
                selector: "#expiration-date",
                placeholder: "MM/YYYY"
              },
              postalCode: {
                selector: "#postal-code",
                placeholder: "11111"
              }
            }
          },
          function(hostedFieldsErr, hostedFieldsInstance) {
            if (hostedFieldsErr) {
              // do error stuff
              return;
            }
            submit.removeAttr("disabled");

            form.addEventListener("submit", function(event) {
              event.preventDefault();

              hostedFieldsInstance.tokenize(function(tokenizeErr, payload) {
                if (tokenizeErr) {
                  // Handle error in Hosted Fields tokenization
                  return;
                }
                document.querySelector('input[name="payment_method_nonce"]').value = payload.nonce;
                form.submit();
              });
            });
          }
        );
      }
    );
});
