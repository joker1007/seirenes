Seirenes.sortOrders = [
  Ember.Object.create({orderName: "タイトル(昇順)", sortOrderBy: "title_sort asc"}),
  Ember.Object.create({orderName: "タイトル(降順)", sortOrderBy: "title_sort desc"}),
  Ember.Object.create({orderName: "投稿日(新しい順)", sortOrderBy: "nico_posted_at desc"}),
  Ember.Object.create({orderName: "投稿日(古い順)", sortOrderBy: "nico_posted_at asc"}),
  Ember.Object.create({orderName: "マイリスト(多い順)", sortOrderBy: "nico_mylist_count desc"})
  Ember.Object.create({orderName: "マイリスト数(少ない順)", sortOrderBy: "nico_mylist_count asc"}),
]
