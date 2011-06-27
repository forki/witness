/*
	multi-text-middleware.js
*/

(function (fingers) {

    fingers.middleware.addStaticMethods({

        multiText: fingers.middleware.createChild('select-middleware')

    });

    fingers.middleware.multiText.addInstanceMethods({

        

        // This needs a custom showStaticView which pulls out the inner text of the option tag, rather than the internal value. 

        showStaticView : function(){
            // get value out...
            var rawValue = fingers.formData.value(this.uid);

            // then find the inner text of the relevant option....
            // and display that instead, or if it's a vlaue of '' then display click to edit.

            if (rawValue === '') {
                rawValue = 'Click to edit';
            }

            var value = rawValue.replace(/\|/g, ', ');



            this.staticView.html(value).show();

            return this;

        },

		persistChange : function(){
					
			// read in all the values of all the inputs that are children of
			// this.editView, turn into a single string with each value separated by a pipe

			var values = [];

			this.editView.find('input.single-text').each(function(){
				
				var val = $(this).val();

				if(val && val !== ''){
					
					values.push( $(this).val() );

				}

			});

			this.okay( values.toString().replace(/,/g, '|') );

			return this;

		},

		beginEdit: function(){
			
			// do something
			var that = this;

			if(fingers.formData.element(this.uid)){

				this.hideStaticView();
				this.showEditView();

	            var rawValue = fingers.formData.value(this.uid);

	            var values = rawValue.split('|');

	            values.forEach(function( element ){

					this.editView.append('<input type="text" value="' + element + '" class="edit-view-control single-text" />');

	            }, this);

	            // then add an empty one..
				this.editView.append('<input type="text" value="" class="edit-view-control single-text last" />');

				this.editView
					.bind('keydown', function( e ) {
						if (e.which === 13) {
							that.persistChange();
						}
						if (e.which === 27){
							that.cancel();							
						}

						if(e.which === 9){
							
							if( $(e.target).is('.last') && e.shiftKey === false){
										
								$(e.target).removeClass('last');
								that.editView.append('<input type="text" value="" class="edit-view-control single-text last" />');


							}

						}
					});


					this.editView.children('.last').focus();

					setTimeout( function(){
						
						$(document).bind('click', {that : that}, that.checkForClick );

					}, 250 );

				
				
			}

			return this;
		

		},

		checkForClick : function( event ){
			
			var that = event.data.that;

			if(!$(event.target).is('input', that.editView)){
				
				that.persistChange();
				
			}

			return this;

		},

		endEdit: function(){

			$(document).unbind('click', this.checkForClick );

			this.hideEditView();
			this.showStaticView();

			// do somethign else
			this.editView.empty();

			return this;

		},

        createEditView : function(){
            
            this.editView = $('<div class="edit-view-control multi-text"></div>');

            return this;

        }


    });

})(fingers);