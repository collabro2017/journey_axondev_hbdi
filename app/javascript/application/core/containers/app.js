import React from 'react';
import {connect} from  'react-redux'
import Layout from '../../home/index.js'
import Header from '../../home/components/header/header.js'
import Footer from '../../home/components/footer/footer.js'
import Results from '../../home/components/results/results.js'
import ReportsSubpage from '../../home/components/reports-subpage'
import ResultsSubpage from '../../home/results-subpage'
import { JourneySubpage } from '../../journey'
import VideoPage from '../../video/components/video-page'

import {
  withRouter,
  Route,
  Link
} from 'react-router-dom'

const Home = () => (
  <Layout/>
)

const Profile = () => (
<ResultsSubpage/>
)

const SavedReports = () => (
<ReportsSubpage/>
)



class App extends React.Component {

  render() {
    return (
      <>
        <>
          <Header/>
            <div>
              <Route exact path="/" component={Home}/>
              <Route path="/profile" component={Profile}/>
              <Route path="/savedreports" component={SavedReports}/>
              <Route path="/journey" component={JourneySubpage}/>
              <Route path="/videos/:videoId" component={VideoPage}/>
            </div>
        </>
        <Footer/>
      </>
    )
  }
};

function select(state){
  return { data: state.app }
}

export default withRouter(connect(select)(App))
