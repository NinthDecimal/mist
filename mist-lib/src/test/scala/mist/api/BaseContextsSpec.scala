package mist.api

import io.hydrosphere.mist.api.{RuntimeJobInfo, SetupConfiguration}
import org.apache.spark.SparkContext
import org.apache.spark.sql.SparkSession
import org.apache.spark.sql.hive.HiveContext
import org.scalatest.{FunSpec, Matchers}

class BaseContextsSpec extends FunSpec with Matchers with TestSparkContext {

  import Contexts._
  import mist.api.args.ArgsInstances._

  it("for spark context") {
   val spJob = arg[Seq[Int]]("nums").onSparkContext(
     (nums: Seq[Int], sp: SparkContext) => {
       sp.parallelize(nums).map(_ * 2).collect()
       Map(1 -> "2")
    })
    val res = spJob.invoke(testCtx("nums" -> (1 to 10)))
    res shouldBe JobSuccess(Map(1 -> "2"))
  }

  it("for only sc") {
    val spJob: Handle[Int] = onSparkContext((sc: SparkContext) => {
      5
    })
    val res = spJob.invoke(testCtx())
    res shouldBe JobSuccess(5)
  }

  def pathToResource(path: String): String = {
    this.getClass.getClassLoader.getResource(path).getPath
  }

  it("session with hive") {
    val spJob = onSparkSessionWithHive((spark: SparkSession) => {
      val df = spark.read.json(pathToResource("hive_job_data.json"))
      df.createOrReplaceTempView("temp")
      df.cache()
      spark.sql("DROP TABLE IF EXISTS temp_hive")
      spark.table("temp").write.saveAsTable("temp_hive")

      spark.sql("SELECT MAX(age) AS avg_age FROM temp_hive")
        .take(1)(0).getLong(0)
    })
    spJob.invoke(testCtx())
    val res = spJob.invoke(testCtx())
    res shouldBe JobSuccess(30)
  }

  def testCtx(params: (String, Any)*): FnContext = {
    val duration = org.apache.spark.streaming.Duration(10 * 1000)
    val setupConf = SetupConfiguration(spark, duration, RuntimeJobInfo("test", "worker"), None)
    FnContext(setupConf, params.toMap)
  }

}
