import consumer from "./consumer"

consumer.subscriptions.create("QuestionsChannel", {
  connected() {
    console.log('connected!! yey!')
    this.perform('follow')
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    $('.questions').append(`<p> ${data} </p>`)
    // Called when there's incoming data on the websocket for this channel
  }
});
