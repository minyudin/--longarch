export default defineAppConfig({
  pages: [
    'pages/login/index',
    'pages/adopter-login/index',
    'pages/operator-login/index',
    'pages/guest-login/index',
    'pages/share-codes/index',
    'pages/operator-workbench/index',
    'pages/adoptions/index',
    'pages/ai-assist/index',
    'pages/plot/index',
    'pages/ai-chat/index',
    'pages/redeem/index',
    'pages/task/index',
    'pages/task-detail/index',
    'pages/camera/index',
    'pages/me/index',
  ],
  window: {
    backgroundTextStyle: 'light',
    navigationBarBackgroundColor: '#e8e8e5',
    navigationBarTitleText: '陇上管家',
    navigationBarTextStyle: 'black',
    backgroundColor: '#e8e8e5',
  },
  tabBar: {
    // custom: true · 我自己画 Folio 风 tabBar, 就不用提供 iconPath PNG 了
    custom: true,
    color: '#8a857b',
    selectedColor: '#2d2a26',
    backgroundColor: '#e8e8e5',
    borderStyle: 'white',
    list: [
      {
        pagePath: 'pages/operator-workbench/index',
        text: '工作台',
      },
      {
        pagePath: 'pages/adoptions/index',
        text: '认养',
      },
      {
        pagePath: 'pages/ai-assist/index',
        text: 'AI询问',
      },
      {
        pagePath: 'pages/me/index',
        text: '我的',
      },
    ],
  },
})
